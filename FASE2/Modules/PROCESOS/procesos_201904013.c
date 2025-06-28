#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched.h>
#include <linux/sched/signal.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("201904013");
MODULE_DESCRIPTION("Modulo Procesos - Monitor de Servicios Linux");

static int escribir_procesos(struct seq_file *archivo, void *v)
{
    struct task_struct *task;
    unsigned long procesos_corriendo = 0;
    unsigned long procesos_durmiendo = 0;
    unsigned long procesos_zombie = 0;
    unsigned long procesos_parados = 0;
    unsigned long total_procesos = 0;

    // Iterar sobre todos los procesos
    for_each_process(task) {
        total_procesos++;

        // Cambiar task->state por task->exit_state (si corresponde con tu versión de kernel)
        switch (task->exit_state) {  // Aquí cambiamos `state` por `exit_state`
            case TASK_RUNNING:
                procesos_corriendo++;
                break;
            case TASK_INTERRUPTIBLE:
            case TASK_UNINTERRUPTIBLE:
                procesos_durmiendo++;
                break;
            case EXIT_ZOMBIE:  // Reemplazar TASK_ZOMBIE por EXIT_ZOMBIE si la versión del kernel lo requiere
                procesos_zombie++;
                break;
            case TASK_STOPPED:
                procesos_parados++;
                break;
            default:
                break;
        }
    }

    // Mostrar los resultados en formato JSON
    seq_printf(archivo,
        "{\n"
        "  \"procesos_corriendo\": %lu,\n"
        "  \"total_procesos\": %lu,\n"
        "  \"procesos_durmiendo\": %lu,\n"
        "  \"procesos_zombie\": %lu,\n"
        "  \"procesos_parados\": %lu\n"
        "}\n",
        procesos_corriendo, total_procesos, procesos_durmiendo,
        procesos_zombie, procesos_parados
    );

    return 0;
}

static int abrir(struct inode *inode, struct file *file)
{
    return single_open(file, escribir_procesos, NULL);
}

static const struct proc_ops operaciones = {
    .proc_open = abrir,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release
};

static int __init iniciar_procesos_modulo(void)
{
    proc_create("procesos_201904013", 0, NULL, &operaciones);
    printk(KERN_INFO "Modulo Procesos 201904013 cargado.\n");
    return 0;
}

static void __exit salir_procesos_modulo(void)
{
    remove_proc_entry("procesos_201904013", NULL);
    printk(KERN_INFO "Modulo Procesos 201904013 removido.\n");
}

module_init(iniciar_procesos_modulo);
module_exit(salir_procesos_modulo);
