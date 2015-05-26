#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/uaccess.h>	/* Needed for copy_from_user */
#include <asm/io.h>		/* Needed for IO Read/Write Functions */
#include <linux/proc_fs.h>	/* Needed for Proc File System Functions */
#include <linux/seq_file.h>	/* Needed for Sequence File Operations */
#include <linux/platform_device.h>	/* Needed for Platform Driver Functions */

/* Define Driver Name */
#define DRIVER_NAME "superip"

unsigned long *base_addr;	/* Vitual Base Address */
struct resource *res;		/* Device Resource Structure */
unsigned long remap_size;	/* Device Memory Size */

/* Write operation for /proc/superip
 * -----------------------------------
 *  When user cat a string to /proc/superip file, the string will be stored in
 *  const char __user *buf. This function will copy the string from user
 *  space into kernel space, and change it to an unsigned long value.
 *  It will then write the value to the register of superip controller,
 *  and turn on the corresponding LEDs eventually.
 */
static ssize_t proc_superip_write(struct file *file, const char __user * buf,
				size_t count, loff_t * ppos)
{
	char superip_str_reg[5];
	char superip_str_value[16];
	
	u32 superip_reg;
	u32 superip_value;

	if (count < 14) {
		if (copy_from_user(superip_str_value, buf, count))
			return -EFAULT;

		superip_str_value[count] = '\0';
	}

	superip_str_reg[0] = '0';
	superip_str_reg[1] = 'x';
	superip_str_reg[2] = superip_str_value[0]; 
	superip_str_reg[3] = superip_str_value[1]; 
	superip_str_reg[4] = '\0';
	
	superip_reg = simple_strtoul(superip_str_reg, NULL, 0);

	superip_str_value[0] = '0';
	superip_str_value[1] = 'x';
		
	superip_value = simple_strtoul(superip_str_value, NULL, 0);

	//superip_value = simple_strtoul(superip_phrase, NULL, 0);

	wmb();
	iowrite32(superip_value, base_addr + superip_reg);
	//iowrite32(superip_value, base_addr);
	return count;
}

/* Callback function when opening file /proc/superip
 * ------------------------------------------------------
 *  Read the register value of superip controller, print the value to
 *  the sequence file struct seq_file *p. In file open operation for /proc/superip
 *  this callback function will be called first to fill up the seq_file,
 *  and seq_read function will print whatever in seq_file to the terminal.
 */
static int proc_superip_show(struct seq_file *p, void *v)
{
	u32 superip_value;
	unsigned int i;
	for(i = 0; i < 32; i++)
	{
		superip_value = ioread32(base_addr + i);
		seq_printf(p, "R 0x%08x V 0x%08x\n", (u32) (base_addr + i), (u32) superip_value);
	}
	return 0;
}

/* Open function for /proc/superip
 * ------------------------------------
 *  When user want to read /proc/superip (i.e. cat /proc/superip), the open function will
 *  be called first. In the open function, a seq_file will be prepared and the status
 *  of superip will be filled into the seq_file by proc_superip_show function.
 */
static int proc_superip_open(struct inode *inode, struct file *file)
{
	unsigned int size = 16;
	char *buf;
	struct seq_file *m;
	int res;

	buf = (char *)kmalloc(size * sizeof(char), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;

	res = single_open(file, proc_superip_show, NULL);

	if (!res) {
		m = file->private_data;
		m->buf = buf;
		m->size = size;
	} else {
		kfree(buf);
	}

	return res;
}

/* File Operations for /proc/superip */
static const struct file_operations proc_superip_operations = {
	.open = proc_superip_open,
	.read = seq_read,
	.write = proc_superip_write,
	.llseek = seq_lseek,
	.release = single_release
};

/* Shutdown function for superip
 * -----------------------------------
 *  Before superip shutdown, turn-off all the leds
 */
static void superip_shutdown(struct platform_device *pdev)
{
	unsigned int i;
	for(i = 0; i < 32; i++)
		iowrite32(0, base_addr + i);
}

/* Remove function for superip
 * ----------------------------------
 *  When superip module is removed, turn off all the leds first,
 *  release virtual address and the memory region requested.
 */
static int superip_remove(struct platform_device *pdev)
{
	superip_shutdown(pdev);

	/* Remove /proc/superip entry */
	remove_proc_entry(DRIVER_NAME, NULL);

	/* Release mapped virtual address */
	iounmap(base_addr);

	/* Release the region */
	release_mem_region(res->start, remap_size);

	return 0;
}

/* Device Probe function for superip
 * ------------------------------------
 *  Get the resource structure from the information in device tree.
 *  request the memory regioon needed for the controller, and map it into
 *  kernel virtual memory space. Create an entry under /proc file system
 *  and register file operations for that entry.
 */
static int __devinit superip_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *superip_proc_entry;
	int ret = 0;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
		dev_err(&pdev->dev, "No memory resource\n");
		return -ENODEV;
	}

	remap_size = res->end - res->start + 1;
	if (!request_mem_region(res->start, remap_size, pdev->name)) {
		dev_err(&pdev->dev, "Cannot request IO\n");
		return -ENXIO;
	}

	base_addr = ioremap(res->start, remap_size);
	if (base_addr == NULL) {
		dev_err(&pdev->dev, "Couldn't ioremap memory at 0x%08lx\n",
			(unsigned long)res->start);
		ret = -ENOMEM;
		goto err_release_region;
	}

	superip_proc_entry = proc_create(DRIVER_NAME, 0, NULL,
				       &proc_superip_operations);
	if (superip_proc_entry == NULL) {
		dev_err(&pdev->dev, "Couldn't create proc entry\n");
		ret = -ENOMEM;
		goto err_create_proc_entry;
	}

	printk(KERN_INFO DRIVER_NAME " probed at va 0x%08lx\n",
	       (unsigned long)base_addr);

	return 0;

 err_create_proc_entry:
	iounmap(base_addr);
 err_release_region:
	release_mem_region(res->start, remap_size);

	return ret;
}

/* device match table to match with device node in device tree */
static const struct of_device_id superip_of_match[] __devinitconst = {
	{.compatible = "dglnt,superip-1.00.a"},
	{},
};

MODULE_DEVICE_TABLE(of, superip_of_match);

/* platform driver structure for superip driver */
static struct platform_driver superip_driver = {
	.driver = {
		   .name = DRIVER_NAME,
		   .owner = THIS_MODULE,
		   .of_match_table = superip_of_match},
	.probe = superip_probe,
	.remove = __devexit_p(superip_remove),
	.shutdown = __devexit_p(superip_shutdown)
};

/* Register superip platform driver */
module_platform_driver(superip_driver);

/* Module Infomations */
MODULE_AUTHOR("Digilent, Inc.");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DRIVER_NAME ": MYLED driver (Simple Version)");
MODULE_ALIAS(DRIVER_NAME);
