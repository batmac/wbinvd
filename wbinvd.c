
/* https://c9x.me/x86/html/file_module_x86_id_325.html */
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/smp.h>
#include <linux/seq_file.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Baptiste Canton <batmac@gmail.com>");
MODULE_DESCRIPTION("execute WBINVD on demand");

#ifndef PROCFILE_NAME
#define PROCFILE_NAME "wbinvd"
#endif

static struct proc_dir_entry *procfile;

static int wbinvd_show(struct seq_file *m, void *v)
{	
	unsigned int cpu = get_cpu(); /* preempt off */
	pr_info("%s: _show requested, executing WBINVD on all CPUs, from CPU %u\n",THIS_MODULE->name,cpu);
	wbinvd_on_all_cpus();
	put_cpu(); /* preempt on */
	seq_printf(m, "WBINVD executed from CPU %u\n",cpu);
	return 0;
}
static int wbinvd_open(struct inode *inode, struct file *file)
{
	return  single_open(file,wbinvd_show,NULL);
}


#ifdef HAVE_PROC_OPS
static const struct proc_ops wbinvd_ops = {
	.proc_open    = wbinvd_open,
	.proc_read    = seq_read,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};
#else
static const struct file_operations wbinvd_fops = {
	.owner   = THIS_MODULE,
	.open    = wbinvd_open,
	.read    = seq_read,
	.llseek  = seq_lseek,
	.release = single_release,
};
#define wbinvd_ops wbinvd_fops
#endif

static int __init wbinvd_init(void)
{
	procfile = proc_create(PROCFILE_NAME,0400,NULL,&wbinvd_ops);
	if(!procfile) {
		proc_remove(procfile);
		pr_alert("%s: Error: Could not initialize /proc/%s\n",THIS_MODULE->name,PROCFILE_NAME);
		return -ENODEV;
	}
	pr_info("%s: loaded. /proc/%s created\n",THIS_MODULE->name,PROCFILE_NAME);
	return 0;
}

static void __exit wbinvd_exit(void)
{
	proc_remove(procfile);
	pr_info("%s: unloaded. /proc/%s removed\n",THIS_MODULE->name,PROCFILE_NAME);
}


module_init(wbinvd_init);
module_exit(wbinvd_exit); 
