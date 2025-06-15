#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched.h>
#include <linux/sched/signal.h>
#include <linux/timekeeping.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("201904013");
MODULE_DESCRIPTION("Modulo CPU - Monitor de Servicios Linux");

static int escribir_cpu(struct seq_file *archivo, void *v)
{
    struct task_struct *task;
    u64 total_cpu = 0;
    u64 uso_cpu = 0;
    u64 libre_cpu = 0;
    u64 porcentaje = 0;

    // Tiempo total de uso de todos los procesos en nanosegundos
    for_each_process(task)
    {
        uso_cpu += task->utime + task->stime;
    }

    // Tiempo total del sistema desde el arranque en nanosegundos
    total_cpu = ktime_to_ns(ktime_get());

    if (total_cpu > 0)
    {
        porcentaje = (uso_cpu * 10000) / total_cpu; // 0–10000 = 0.00%–100.00%
        libre_cpu = total_cpu - uso_cpu;

        // Convertir a milisegundos para hacerlo más legible
        total_cpu /= 1000000;
        uso_cpu /= 1000000;
        libre_cpu /= 1000000;
    }

    seq_printf(archivo,
               "{\n"
               "  \"total\": %llu,\n"
               "  \"uso\": %llu,\n"
               "  \"libre\": %llu,\n"
               "  \"porcentaje\": %llu\n"
               "}\n",
               total_cpu, uso_cpu, libre_cpu, porcentaje);

    return 0;
}

static int abrir(struct inode *inode, struct file *file)
{
    return single_open(file, escribir_cpu, NULL);
}

static struct proc_ops operaciones = {
    .proc_open = abrir,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release
};

static int __init iniciar_cpu_modulo(void)
{
    proc_create("cpu_201904013", 0, NULL, &operaciones);
    printk(KERN_INFO "Modulo CPU 201904013 cargado.\n");
    return 0;
}

static void __exit salir_cpu_modulo(void)
{
    remove_proc_entry("cpu_201904013", NULL);
    printk(KERN_INFO "Modulo CPU 201904013 removido.\n");
}

module_init(iniciar_cpu_modulo);
module_exit(salir_cpu_modulo);
