#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/mm.h>
#include <linux/sysinfo.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("201904013");
MODULE_DESCRIPTION("Modulo RAM - Monitor de Servicios Linux");

static int escribir_ram(struct seq_file *archivo, void *v)
{
    struct sysinfo info;
    unsigned long total, libre, uso, porcentaje;

    si_meminfo(&info);

    // Convertimos de bytes a KB
    total = (info.totalram * info.mem_unit) / 1024;
    libre = (info.freeram * info.mem_unit) / 1024;
    uso = total - libre;

    if (total > 0) {
        porcentaje = (uso * 10000) / total;  // 0 - 10000 (equivale a 100.00%)
    } else {
        porcentaje = 0;
    }

    seq_printf(archivo, "{\n");
    seq_printf(archivo, "  \"total\": %lu,\n", total);
    seq_printf(archivo, "  \"libre\": %lu,\n", libre);
    seq_printf(archivo, "  \"uso\": %lu,\n", uso);
    seq_printf(archivo, "  \"porcentaje\": %lu\n", porcentaje);
    seq_printf(archivo, "}\n");

    return 0;
}

static int abrir(struct inode *inode, struct file *file)
{
    return single_open(file, escribir_ram, NULL);
}

static struct proc_ops operaciones = {
    .proc_open = abrir,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release
};

static int __init iniciar_ram_modulo(void)
{
    proc_create("ram_201904013", 0, NULL, &operaciones);
    printk(KERN_INFO "Modulo RAM 201904013 cargado.\n");
    return 0;
}

static void __exit salir_ram_modulo(void)
{
    remove_proc_entry("ram_201904013", NULL);
    printk(KERN_INFO "Modulo RAM 201904013 descargado.\n");
}

module_init(iniciar_ram_modulo);
module_exit(salir_ram_modulo);
