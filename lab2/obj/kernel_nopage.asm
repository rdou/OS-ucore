
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 7a 11 00       	push   $0x117a36
  100049:	e8 48 56 00 00       	call   105696 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 53 15 00 00       	call   1015a9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 40 5e 10 00 	movl   $0x105e40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 5c 5e 10 00       	push   $0x105e5c
  100068:	e8 fa 01 00 00       	call   100267 <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 7c 08 00 00       	call   1008f1 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 b4 30 00 00       	call   103133 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 97 16 00 00       	call   10171b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 f8 17 00 00       	call   101881 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 c2 0c 00 00       	call   100d50 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 c5 17 00 00       	call   101858 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 95 0c 00 00       	call   100d3e <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 61 5e 10 00       	push   $0x105e61
  10013c:	e8 26 01 00 00       	call   100267 <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 6f 5e 10 00       	push   $0x105e6f
  10015a:	e8 08 01 00 00       	call   100267 <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 7d 5e 10 00       	push   $0x105e7d
  100178:	e8 ea 00 00 00       	call   100267 <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 8b 5e 10 00       	push   $0x105e8b
  100196:	e8 cc 00 00 00       	call   100267 <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 99 5e 10 00       	push   $0x105e99
  1001b4:	e8 ae 00 00 00       	call   100267 <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cf:	90                   	nop
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d5:	90                   	nop
  1001d6:	5d                   	pop    %ebp
  1001d7:	c3                   	ret    

001001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d8:	55                   	push   %ebp
  1001d9:	89 e5                	mov    %esp,%ebp
  1001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001de:	e8 2c ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 a8 5e 10 00       	push   $0x105ea8
  1001eb:	e8 77 00 00 00       	call   100267 <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f3:	e8 d4 ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f8:	e8 12 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fd:	83 ec 0c             	sub    $0xc,%esp
  100200:	68 c8 5e 10 00       	push   $0x105ec8
  100205:	e8 5d 00 00 00       	call   100267 <cprintf>
  10020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10020d:	e8 c0 ff ff ff       	call   1001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 f8 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  100217:	90                   	nop
  100218:	c9                   	leave  
  100219:	c3                   	ret    

0010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
  10021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100220:	83 ec 0c             	sub    $0xc,%esp
  100223:	ff 75 08             	pushl  0x8(%ebp)
  100226:	e8 af 13 00 00       	call   1015da <cons_putc>
  10022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100231:	8b 00                	mov    (%eax),%eax
  100233:	8d 50 01             	lea    0x1(%eax),%edx
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 10                	mov    %edx,(%eax)
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024b:	ff 75 0c             	pushl  0xc(%ebp)
  10024e:	ff 75 08             	pushl  0x8(%ebp)
  100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100254:	50                   	push   %eax
  100255:	68 1a 02 10 00       	push   $0x10021a
  10025a:	e8 6d 57 00 00       	call   1059cc <vprintfmt>
  10025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100265:	c9                   	leave  
  100266:	c3                   	ret    

00100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100267:	55                   	push   %ebp
  100268:	89 e5                	mov    %esp,%ebp
  10026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10026d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100276:	83 ec 08             	sub    $0x8,%esp
  100279:	50                   	push   %eax
  10027a:	ff 75 08             	pushl  0x8(%ebp)
  10027d:	e8 bc ff ff ff       	call   10023e <vcprintf>
  100282:	83 c4 10             	add    $0x10,%esp
  100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028b:	c9                   	leave  
  10028c:	c3                   	ret    

0010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10028d:	55                   	push   %ebp
  10028e:	89 e5                	mov    %esp,%ebp
  100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100293:	83 ec 0c             	sub    $0xc,%esp
  100296:	ff 75 08             	pushl  0x8(%ebp)
  100299:	e8 3c 13 00 00       	call   1015da <cons_putc>
  10029e:	83 c4 10             	add    $0x10,%esp
}
  1002a1:	90                   	nop
  1002a2:	c9                   	leave  
  1002a3:	c3                   	ret    

001002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b1:	eb 14                	jmp    1002c7 <cputs+0x23>
        cputch(c, &cnt);
  1002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b7:	83 ec 08             	sub    $0x8,%esp
  1002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bd:	52                   	push   %edx
  1002be:	50                   	push   %eax
  1002bf:	e8 56 ff ff ff       	call   10021a <cputch>
  1002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	8d 50 01             	lea    0x1(%eax),%edx
  1002cd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d0:	0f b6 00             	movzbl (%eax),%eax
  1002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002da:	75 d7                	jne    1002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dc:	83 ec 08             	sub    $0x8,%esp
  1002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e2:	50                   	push   %eax
  1002e3:	6a 0a                	push   $0xa
  1002e5:	e8 30 ff ff ff       	call   10021a <cputch>
  1002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f0:	c9                   	leave  
  1002f1:	c3                   	ret    

001002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f2:	55                   	push   %ebp
  1002f3:	89 e5                	mov    %esp,%ebp
  1002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002f8:	e8 26 13 00 00       	call   101623 <cons_getc>
  1002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100304:	74 f2                	je     1002f8 <getchar+0x6>
        /* do nothing */;
    return c;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100315:	74 13                	je     10032a <readline+0x1f>
        cprintf("%s", prompt);
  100317:	83 ec 08             	sub    $0x8,%esp
  10031a:	ff 75 08             	pushl  0x8(%ebp)
  10031d:	68 e7 5e 10 00       	push   $0x105ee7
  100322:	e8 40 ff ff ff       	call   100267 <cprintf>
  100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100331:	e8 bc ff ff ff       	call   1002f2 <getchar>
  100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033d:	79 0a                	jns    100349 <readline+0x3e>
            return NULL;
  10033f:	b8 00 00 00 00       	mov    $0x0,%eax
  100344:	e9 82 00 00 00       	jmp    1003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 2b                	jle    10037a <readline+0x6f>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 22                	jg     10037a <readline+0x6f>
            cputchar(c);
  100358:	83 ec 0c             	sub    $0xc,%esp
  10035b:	ff 75 f0             	pushl  -0x10(%ebp)
  10035e:	e8 2a ff ff ff       	call   10028d <cputchar>
  100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100369:	8d 50 01             	lea    0x1(%eax),%edx
  10036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100372:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100378:	eb 4c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037e:	75 1a                	jne    10039a <readline+0x8f>
  100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100384:	7e 14                	jle    10039a <readline+0x8f>
            cputchar(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 f0             	pushl  -0x10(%ebp)
  10038c:	e8 fc fe ff ff       	call   10028d <cputchar>
  100391:	83 c4 10             	add    $0x10,%esp
            i --;
  100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100398:	eb 2c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039e:	74 06                	je     1003a6 <readline+0x9b>
  1003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a4:	75 8b                	jne    100331 <readline+0x26>
            cputchar(c);
  1003a6:	83 ec 0c             	sub    $0xc,%esp
  1003a9:	ff 75 f0             	pushl  -0x10(%ebp)
  1003ac:	e8 dc fe ff ff       	call   10028d <cputchar>
  1003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b7:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003bf:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003c4:	eb 05                	jmp    1003cb <readline+0xc0>
        }
    }
  1003c6:	e9 66 ff ff ff       	jmp    100331 <readline+0x26>
}
  1003cb:	c9                   	leave  
  1003cc:	c3                   	ret    

001003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003cd:	55                   	push   %ebp
  1003ce:	89 e5                	mov    %esp,%ebp
  1003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003d8:	85 c0                	test   %eax,%eax
  1003da:	75 4a                	jne    100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003dc:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ec:	83 ec 04             	sub    $0x4,%esp
  1003ef:	ff 75 0c             	pushl  0xc(%ebp)
  1003f2:	ff 75 08             	pushl  0x8(%ebp)
  1003f5:	68 ea 5e 10 00       	push   $0x105eea
  1003fa:	e8 68 fe ff ff       	call   100267 <cprintf>
  1003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100405:	83 ec 08             	sub    $0x8,%esp
  100408:	50                   	push   %eax
  100409:	ff 75 10             	pushl  0x10(%ebp)
  10040c:	e8 2d fe ff ff       	call   10023e <vcprintf>
  100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100414:	83 ec 0c             	sub    $0xc,%esp
  100417:	68 06 5f 10 00       	push   $0x105f06
  10041c:	e8 46 fe ff ff       	call   100267 <cprintf>
  100421:	83 c4 10             	add    $0x10,%esp
  100424:	eb 01                	jmp    100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100427:	e8 33 14 00 00       	call   10185f <intr_disable>
    while (1) {
        kmonitor(NULL);
  10042c:	83 ec 0c             	sub    $0xc,%esp
  10042f:	6a 00                	push   $0x0
  100431:	e8 2e 08 00 00       	call   100c64 <kmonitor>
  100436:	83 c4 10             	add    $0x10,%esp
    }
  100439:	eb f1                	jmp    10042c <__panic+0x5f>

0010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043b:	55                   	push   %ebp
  10043c:	89 e5                	mov    %esp,%ebp
  10043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100441:	8d 45 14             	lea    0x14(%ebp),%eax
  100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100447:	83 ec 04             	sub    $0x4,%esp
  10044a:	ff 75 0c             	pushl  0xc(%ebp)
  10044d:	ff 75 08             	pushl  0x8(%ebp)
  100450:	68 08 5f 10 00       	push   $0x105f08
  100455:	e8 0d fe ff ff       	call   100267 <cprintf>
  10045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100460:	83 ec 08             	sub    $0x8,%esp
  100463:	50                   	push   %eax
  100464:	ff 75 10             	pushl  0x10(%ebp)
  100467:	e8 d2 fd ff ff       	call   10023e <vcprintf>
  10046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10046f:	83 ec 0c             	sub    $0xc,%esp
  100472:	68 06 5f 10 00       	push   $0x105f06
  100477:	e8 eb fd ff ff       	call   100267 <cprintf>
  10047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10047f:	90                   	nop
  100480:	c9                   	leave  
  100481:	c3                   	ret    

00100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100485:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  10048a:	5d                   	pop    %ebp
  10048b:	c3                   	ret    

0010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10048c:	55                   	push   %ebp
  10048d:	89 e5                	mov    %esp,%ebp
  10048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 00                	mov    (%eax),%eax
  100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049a:	8b 45 10             	mov    0x10(%ebp),%eax
  10049d:	8b 00                	mov    (%eax),%eax
  10049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004a9:	e9 d2 00 00 00       	jmp    100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	89 c2                	mov    %eax,%edx
  1004b8:	c1 ea 1f             	shr    $0x1f,%edx
  1004bb:	01 d0                	add    %edx,%eax
  1004bd:	d1 f8                	sar    %eax
  1004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c8:	eb 04                	jmp    1004ce <stab_binsearch+0x42>
            m --;
  1004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d4:	7c 1f                	jl     1004f5 <stab_binsearch+0x69>
  1004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d9:	89 d0                	mov    %edx,%eax
  1004db:	01 c0                	add    %eax,%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	c1 e0 02             	shl    $0x2,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ed:	0f b6 c0             	movzbl %al,%eax
  1004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f3:	75 d5                	jne    1004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fb:	7d 0b                	jge    100508 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100500:	83 c0 01             	add    $0x1,%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100506:	eb 78                	jmp    100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100512:	89 d0                	mov    %edx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	c1 e0 02             	shl    $0x2,%eax
  10051b:	89 c2                	mov    %eax,%edx
  10051d:	8b 45 08             	mov    0x8(%ebp),%eax
  100520:	01 d0                	add    %edx,%eax
  100522:	8b 40 08             	mov    0x8(%eax),%eax
  100525:	3b 45 18             	cmp    0x18(%ebp),%eax
  100528:	73 13                	jae    10053d <stab_binsearch+0xb1>
            *region_left = m;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100535:	83 c0 01             	add    $0x1,%eax
  100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053b:	eb 43                	jmp    100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100540:	89 d0                	mov    %edx,%eax
  100542:	01 c0                	add    %eax,%eax
  100544:	01 d0                	add    %edx,%eax
  100546:	c1 e0 02             	shl    $0x2,%eax
  100549:	89 c2                	mov    %eax,%edx
  10054b:	8b 45 08             	mov    0x8(%ebp),%eax
  10054e:	01 d0                	add    %edx,%eax
  100550:	8b 40 08             	mov    0x8(%eax),%eax
  100553:	3b 45 18             	cmp    0x18(%ebp),%eax
  100556:	76 16                	jbe    10056e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055e:	8b 45 10             	mov    0x10(%ebp),%eax
  100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100566:	83 e8 01             	sub    $0x1,%eax
  100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056c:	eb 12                	jmp    100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100574:	89 10                	mov    %edx,(%eax)
            l = m;
  100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100586:	0f 8e 22 ff ff ff    	jle    1004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100590:	75 0f                	jne    1005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	8b 00                	mov    (%eax),%eax
  100597:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059a:	8b 45 10             	mov    0x10(%ebp),%eax
  10059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059f:	eb 3f                	jmp    1005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a9:	eb 04                	jmp    1005af <stab_binsearch+0x123>
  1005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b2:	8b 00                	mov    (%eax),%eax
  1005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b7:	7d 1f                	jge    1005d8 <stab_binsearch+0x14c>
  1005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005bc:	89 d0                	mov    %edx,%eax
  1005be:	01 c0                	add    %eax,%eax
  1005c0:	01 d0                	add    %edx,%eax
  1005c2:	c1 e0 02             	shl    $0x2,%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ca:	01 d0                	add    %edx,%eax
  1005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d0:	0f b6 c0             	movzbl %al,%eax
  1005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d6:	75 d3                	jne    1005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005de:	89 10                	mov    %edx,(%eax)
    }
}
  1005e0:	90                   	nop
  1005e1:	c9                   	leave  
  1005e2:	c3                   	ret    

001005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e3:	55                   	push   %ebp
  1005e4:	89 e5                	mov    %esp,%ebp
  1005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 00 28 5f 10 00    	movl   $0x105f28,(%eax)
    info->eip_line = 0;
  1005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ff:	c7 40 08 28 5f 10 00 	movl   $0x105f28,0x8(%eax)
    info->eip_fn_namelen = 9;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
  100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100619:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100623:	c7 45 f4 f4 71 10 00 	movl   $0x1071f4,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062a:	c7 45 f0 0c 23 11 00 	movl   $0x11230c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100631:	c7 45 ec 0d 23 11 00 	movl   $0x11230d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100638:	c7 45 e8 45 4e 11 00 	movl   $0x114e45,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100645:	76 0d                	jbe    100654 <debuginfo_eip+0x71>
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	83 e8 01             	sub    $0x1,%eax
  10064d:	0f b6 00             	movzbl (%eax),%eax
  100650:	84 c0                	test   %al,%al
  100652:	74 0a                	je     10065e <debuginfo_eip+0x7b>
        return -1;
  100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100659:	e9 91 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066b:	29 c2                	sub    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	c1 f8 02             	sar    $0x2,%eax
  100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100678:	83 e8 01             	sub    $0x1,%eax
  10067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10067e:	ff 75 08             	pushl  0x8(%ebp)
  100681:	6a 64                	push   $0x64
  100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100686:	50                   	push   %eax
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	50                   	push   %eax
  10068b:	ff 75 f4             	pushl  -0xc(%ebp)
  10068e:	e8 f9 fd ff ff       	call   10048c <stab_binsearch>
  100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100699:	85 c0                	test   %eax,%eax
  10069b:	75 0a                	jne    1006a7 <debuginfo_eip+0xc4>
        return -1;
  10069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a2:	e9 48 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b3:	ff 75 08             	pushl  0x8(%ebp)
  1006b6:	6a 24                	push   $0x24
  1006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bb:	50                   	push   %eax
  1006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006bf:	50                   	push   %eax
  1006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c3:	e8 c4 fd ff ff       	call   10048c <stab_binsearch>
  1006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d1:	39 c2                	cmp    %eax,%edx
  1006d3:	7f 7c                	jg     100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d8:	89 c2                	mov    %eax,%edx
  1006da:	89 d0                	mov    %edx,%eax
  1006dc:	01 c0                	add    %eax,%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	c1 e0 02             	shl    $0x2,%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e8:	01 d0                	add    %edx,%eax
  1006ea:	8b 00                	mov    (%eax),%eax
  1006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f2:	29 d1                	sub    %edx,%ecx
  1006f4:	89 ca                	mov    %ecx,%edx
  1006f6:	39 d0                	cmp    %edx,%eax
  1006f8:	73 22                	jae    10071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fd:	89 c2                	mov    %eax,%edx
  1006ff:	89 d0                	mov    %edx,%eax
  100701:	01 c0                	add    %eax,%eax
  100703:	01 d0                	add    %edx,%eax
  100705:	c1 e0 02             	shl    $0x2,%eax
  100708:	89 c2                	mov    %eax,%edx
  10070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	8b 10                	mov    (%eax),%edx
  100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100714:	01 c2                	add    %eax,%edx
  100716:	8b 45 0c             	mov    0xc(%ebp),%eax
  100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071f:	89 c2                	mov    %eax,%edx
  100721:	89 d0                	mov    %edx,%eax
  100723:	01 c0                	add    %eax,%eax
  100725:	01 d0                	add    %edx,%eax
  100727:	c1 e0 02             	shl    $0x2,%eax
  10072a:	89 c2                	mov    %eax,%edx
  10072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072f:	01 d0                	add    %edx,%eax
  100731:	8b 50 08             	mov    0x8(%eax),%edx
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073d:	8b 40 10             	mov    0x10(%eax),%eax
  100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10074f:	eb 15                	jmp    100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	8b 55 08             	mov    0x8(%ebp),%edx
  100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	8b 40 08             	mov    0x8(%eax),%eax
  10076c:	83 ec 08             	sub    $0x8,%esp
  10076f:	6a 3a                	push   $0x3a
  100771:	50                   	push   %eax
  100772:	e8 93 4d 00 00       	call   10550a <strfind>
  100777:	83 c4 10             	add    $0x10,%esp
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077f:	8b 40 08             	mov    0x8(%eax),%eax
  100782:	29 c2                	sub    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078a:	83 ec 0c             	sub    $0xc,%esp
  10078d:	ff 75 08             	pushl  0x8(%ebp)
  100790:	6a 44                	push   $0x44
  100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100795:	50                   	push   %eax
  100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100799:	50                   	push   %eax
  10079a:	ff 75 f4             	pushl  -0xc(%ebp)
  10079d:	e8 ea fc ff ff       	call   10048c <stab_binsearch>
  1007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ab:	39 c2                	cmp    %eax,%edx
  1007ad:	7f 24                	jg     1007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c8:	0f b7 d0             	movzwl %ax,%edx
  1007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d1:	eb 13                	jmp    1007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d8:	e9 12 01 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e0:	83 e8 01             	sub    $0x1,%eax
  1007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ec:	39 c2                	cmp    %eax,%edx
  1007ee:	7c 56                	jl     100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100809:	3c 84                	cmp    $0x84,%al
  10080b:	74 39                	je     100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100826:	3c 64                	cmp    $0x64,%al
  100828:	75 b3                	jne    1007dd <debuginfo_eip+0x1fa>
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	89 d0                	mov    %edx,%eax
  100831:	01 c0                	add    %eax,%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	c1 e0 02             	shl    $0x2,%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	8b 40 08             	mov    0x8(%eax),%eax
  100842:	85 c0                	test   %eax,%eax
  100844:	74 97                	je     1007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084c:	39 c2                	cmp    %eax,%edx
  10084e:	7c 46                	jl     100896 <debuginfo_eip+0x2b3>
  100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100853:	89 c2                	mov    %eax,%edx
  100855:	89 d0                	mov    %edx,%eax
  100857:	01 c0                	add    %eax,%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	c1 e0 02             	shl    $0x2,%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100863:	01 d0                	add    %edx,%eax
  100865:	8b 00                	mov    (%eax),%eax
  100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10086d:	29 d1                	sub    %edx,%ecx
  10086f:	89 ca                	mov    %ecx,%edx
  100871:	39 d0                	cmp    %edx,%eax
  100873:	73 21                	jae    100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 10                	mov    (%eax),%edx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	01 c2                	add    %eax,%edx
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089c:	39 c2                	cmp    %eax,%edx
  10089e:	7d 4a                	jge    1008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a9:	eb 18                	jmp    1008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ae:	8b 40 14             	mov    0x14(%eax),%eax
  1008b1:	8d 50 01             	lea    0x1(%eax),%edx
  1008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bd:	83 c0 01             	add    $0x1,%eax
  1008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008c9:	39 c2                	cmp    %eax,%edx
  1008cb:	7d 1d                	jge    1008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e6:	3c a0                	cmp    $0xa0,%al
  1008e8:	74 c1                	je     1008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ef:	c9                   	leave  
  1008f0:	c3                   	ret    

001008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f1:	55                   	push   %ebp
  1008f2:	89 e5                	mov    %esp,%ebp
  1008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f7:	83 ec 0c             	sub    $0xc,%esp
  1008fa:	68 32 5f 10 00       	push   $0x105f32
  1008ff:	e8 63 f9 ff ff       	call   100267 <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 2a 00 10 00       	push   $0x10002a
  10090f:	68 4b 5f 10 00       	push   $0x105f4b
  100914:	e8 4e f9 ff ff       	call   100267 <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 2d 5e 10 00       	push   $0x105e2d
  100924:	68 63 5f 10 00       	push   $0x105f63
  100929:	e8 39 f9 ff ff       	call   100267 <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100931:	83 ec 08             	sub    $0x8,%esp
  100934:	68 36 7a 11 00       	push   $0x117a36
  100939:	68 7b 5f 10 00       	push   $0x105f7b
  10093e:	e8 24 f9 ff ff       	call   100267 <cprintf>
  100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100946:	83 ec 08             	sub    $0x8,%esp
  100949:	68 68 89 11 00       	push   $0x118968
  10094e:	68 93 5f 10 00       	push   $0x105f93
  100953:	e8 0f f9 ff ff       	call   100267 <cprintf>
  100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095b:	b8 68 89 11 00       	mov    $0x118968,%eax
  100960:	05 ff 03 00 00       	add    $0x3ff,%eax
  100965:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096a:	29 d0                	sub    %edx,%eax
  10096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100972:	85 c0                	test   %eax,%eax
  100974:	0f 48 c2             	cmovs  %edx,%eax
  100977:	c1 f8 0a             	sar    $0xa,%eax
  10097a:	83 ec 08             	sub    $0x8,%esp
  10097d:	50                   	push   %eax
  10097e:	68 ac 5f 10 00       	push   $0x105fac
  100983:	e8 df f8 ff ff       	call   100267 <cprintf>
  100988:	83 c4 10             	add    $0x10,%esp
}
  10098b:	90                   	nop
  10098c:	c9                   	leave  
  10098d:	c3                   	ret    

0010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10098e:	55                   	push   %ebp
  10098f:	89 e5                	mov    %esp,%ebp
  100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100997:	83 ec 08             	sub    $0x8,%esp
  10099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10099d:	50                   	push   %eax
  10099e:	ff 75 08             	pushl  0x8(%ebp)
  1009a1:	e8 3d fc ff ff       	call   1005e3 <debuginfo_eip>
  1009a6:	83 c4 10             	add    $0x10,%esp
  1009a9:	85 c0                	test   %eax,%eax
  1009ab:	74 15                	je     1009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ad:	83 ec 08             	sub    $0x8,%esp
  1009b0:	ff 75 08             	pushl  0x8(%ebp)
  1009b3:	68 d6 5f 10 00       	push   $0x105fd6
  1009b8:	e8 aa f8 ff ff       	call   100267 <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c0:	eb 65                	jmp    100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009c9:	eb 1c                	jmp    1009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	01 d0                	add    %edx,%eax
  1009d3:	0f b6 00             	movzbl (%eax),%eax
  1009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009df:	01 ca                	add    %ecx,%edx
  1009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009ed:	7f dc                	jg     1009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	01 d0                	add    %edx,%eax
  1009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a00:	8b 55 08             	mov    0x8(%ebp),%edx
  100a03:	89 d1                	mov    %edx,%ecx
  100a05:	29 c1                	sub    %eax,%ecx
  100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a0d:	83 ec 0c             	sub    $0xc,%esp
  100a10:	51                   	push   %ecx
  100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a17:	51                   	push   %ecx
  100a18:	52                   	push   %edx
  100a19:	50                   	push   %eax
  100a1a:	68 f2 5f 10 00       	push   $0x105ff2
  100a1f:	e8 43 f8 ff ff       	call   100267 <cprintf>
  100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a27:	90                   	nop
  100a28:	c9                   	leave  
  100a29:	c3                   	ret    

00100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2a:	55                   	push   %ebp
  100a2b:	89 e5                	mov    %esp,%ebp
  100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a30:	8b 45 04             	mov    0x4(%ebp),%eax
  100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a39:	c9                   	leave  
  100a3a:	c3                   	ret    

00100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3b:	55                   	push   %ebp
  100a3c:	89 e5                	mov    %esp,%ebp
  100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a41:	89 e8                	mov    %ebp,%eax
  100a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp, eip;
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
  100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    eip = read_eip();
  100a4c:	e8 d9 ff ff ff       	call   100a2a <read_eip>
  100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
  100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a5b:	e9 85 00 00 00       	jmp    100ae5 <print_stackframe+0xaa>
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
  100a60:	83 ec 04             	sub    $0x4,%esp
  100a63:	ff 75 f0             	pushl  -0x10(%ebp)
  100a66:	ff 75 f4             	pushl  -0xc(%ebp)
  100a69:	68 04 60 10 00       	push   $0x106004
  100a6e:	e8 f4 f7 ff ff       	call   100267 <cprintf>
  100a73:	83 c4 10             	add    $0x10,%esp
        
        for( i = 0; i < 4; i++ ) 
  100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a7d:	eb 27                	jmp    100aa6 <print_stackframe+0x6b>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
  100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a82:	c1 e0 02             	shl    $0x2,%eax
  100a85:	89 c2                	mov    %eax,%edx
  100a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8a:	01 d0                	add    %edx,%eax
  100a8c:	83 c0 08             	add    $0x8,%eax
  100a8f:	8b 00                	mov    (%eax),%eax
  100a91:	83 ec 08             	sub    $0x8,%esp
  100a94:	50                   	push   %eax
  100a95:	68 25 60 10 00       	push   $0x106025
  100a9a:	e8 c8 f7 ff ff       	call   100267 <cprintf>
  100a9f:	83 c4 10             	add    $0x10,%esp
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
        
        for( i = 0; i < 4; i++ ) 
  100aa2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa6:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aaa:	7e d3                	jle    100a7f <print_stackframe+0x44>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
        
        cprintf( "\n" );
  100aac:	83 ec 0c             	sub    $0xc,%esp
  100aaf:	68 2d 60 10 00       	push   $0x10602d
  100ab4:	e8 ae f7 ff ff       	call   100267 <cprintf>
  100ab9:	83 c4 10             	add    $0x10,%esp
        print_debuginfo( eip - 1 );
  100abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100abf:	83 e8 01             	sub    $0x1,%eax
  100ac2:	83 ec 0c             	sub    $0xc,%esp
  100ac5:	50                   	push   %eax
  100ac6:	e8 c3 fe ff ff       	call   10098e <print_debuginfo>
  100acb:	83 c4 10             	add    $0x10,%esp
        eip = *( ( uint32_t * )( ebp + 4 ) );
  100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad1:	83 c0 04             	add    $0x4,%eax
  100ad4:	8b 00                	mov    (%eax),%eax
  100ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *( ( uint32_t * )( ebp ) );
  100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adc:	8b 00                	mov    (%eax),%eax
  100ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
    eip = read_eip();
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
  100ae1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae9:	74 0a                	je     100af5 <print_stackframe+0xba>
  100aeb:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100aef:	0f 8e 6b ff ff ff    	jle    100a60 <print_stackframe+0x25>
        cprintf( "\n" );
        print_debuginfo( eip - 1 );
        eip = *( ( uint32_t * )( ebp + 4 ) );
        ebp = *( ( uint32_t * )( ebp ) );
    }        
}
  100af5:	90                   	nop
  100af6:	c9                   	leave  
  100af7:	c3                   	ret    

00100af8 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100af8:	55                   	push   %ebp
  100af9:	89 e5                	mov    %esp,%ebp
  100afb:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b05:	eb 0c                	jmp    100b13 <parse+0x1b>
            *buf ++ = '\0';
  100b07:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0a:	8d 50 01             	lea    0x1(%eax),%edx
  100b0d:	89 55 08             	mov    %edx,0x8(%ebp)
  100b10:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b13:	8b 45 08             	mov    0x8(%ebp),%eax
  100b16:	0f b6 00             	movzbl (%eax),%eax
  100b19:	84 c0                	test   %al,%al
  100b1b:	74 1e                	je     100b3b <parse+0x43>
  100b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b20:	0f b6 00             	movzbl (%eax),%eax
  100b23:	0f be c0             	movsbl %al,%eax
  100b26:	83 ec 08             	sub    $0x8,%esp
  100b29:	50                   	push   %eax
  100b2a:	68 b0 60 10 00       	push   $0x1060b0
  100b2f:	e8 a3 49 00 00       	call   1054d7 <strchr>
  100b34:	83 c4 10             	add    $0x10,%esp
  100b37:	85 c0                	test   %eax,%eax
  100b39:	75 cc                	jne    100b07 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3e:	0f b6 00             	movzbl (%eax),%eax
  100b41:	84 c0                	test   %al,%al
  100b43:	74 69                	je     100bae <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b45:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b49:	75 12                	jne    100b5d <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4b:	83 ec 08             	sub    $0x8,%esp
  100b4e:	6a 10                	push   $0x10
  100b50:	68 b5 60 10 00       	push   $0x1060b5
  100b55:	e8 0d f7 ff ff       	call   100267 <cprintf>
  100b5a:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b60:	8d 50 01             	lea    0x1(%eax),%edx
  100b63:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b70:	01 c2                	add    %eax,%edx
  100b72:	8b 45 08             	mov    0x8(%ebp),%eax
  100b75:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b77:	eb 04                	jmp    100b7d <parse+0x85>
            buf ++;
  100b79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b80:	0f b6 00             	movzbl (%eax),%eax
  100b83:	84 c0                	test   %al,%al
  100b85:	0f 84 7a ff ff ff    	je     100b05 <parse+0xd>
  100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8e:	0f b6 00             	movzbl (%eax),%eax
  100b91:	0f be c0             	movsbl %al,%eax
  100b94:	83 ec 08             	sub    $0x8,%esp
  100b97:	50                   	push   %eax
  100b98:	68 b0 60 10 00       	push   $0x1060b0
  100b9d:	e8 35 49 00 00       	call   1054d7 <strchr>
  100ba2:	83 c4 10             	add    $0x10,%esp
  100ba5:	85 c0                	test   %eax,%eax
  100ba7:	74 d0                	je     100b79 <parse+0x81>
            buf ++;
        }
    }
  100ba9:	e9 57 ff ff ff       	jmp    100b05 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bae:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bb2:	c9                   	leave  
  100bb3:	c3                   	ret    

00100bb4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb4:	55                   	push   %ebp
  100bb5:	89 e5                	mov    %esp,%ebp
  100bb7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bba:	83 ec 08             	sub    $0x8,%esp
  100bbd:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc0:	50                   	push   %eax
  100bc1:	ff 75 08             	pushl  0x8(%ebp)
  100bc4:	e8 2f ff ff ff       	call   100af8 <parse>
  100bc9:	83 c4 10             	add    $0x10,%esp
  100bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd3:	75 0a                	jne    100bdf <runcmd+0x2b>
        return 0;
  100bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  100bda:	e9 83 00 00 00       	jmp    100c62 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be6:	eb 59                	jmp    100c41 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100be8:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bee:	89 d0                	mov    %edx,%eax
  100bf0:	01 c0                	add    %eax,%eax
  100bf2:	01 d0                	add    %edx,%eax
  100bf4:	c1 e0 02             	shl    $0x2,%eax
  100bf7:	05 20 70 11 00       	add    $0x117020,%eax
  100bfc:	8b 00                	mov    (%eax),%eax
  100bfe:	83 ec 08             	sub    $0x8,%esp
  100c01:	51                   	push   %ecx
  100c02:	50                   	push   %eax
  100c03:	e8 2f 48 00 00       	call   105437 <strcmp>
  100c08:	83 c4 10             	add    $0x10,%esp
  100c0b:	85 c0                	test   %eax,%eax
  100c0d:	75 2e                	jne    100c3d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c12:	89 d0                	mov    %edx,%eax
  100c14:	01 c0                	add    %eax,%eax
  100c16:	01 d0                	add    %edx,%eax
  100c18:	c1 e0 02             	shl    $0x2,%eax
  100c1b:	05 28 70 11 00       	add    $0x117028,%eax
  100c20:	8b 10                	mov    (%eax),%edx
  100c22:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c25:	83 c0 04             	add    $0x4,%eax
  100c28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c2b:	83 e9 01             	sub    $0x1,%ecx
  100c2e:	83 ec 04             	sub    $0x4,%esp
  100c31:	ff 75 0c             	pushl  0xc(%ebp)
  100c34:	50                   	push   %eax
  100c35:	51                   	push   %ecx
  100c36:	ff d2                	call   *%edx
  100c38:	83 c4 10             	add    $0x10,%esp
  100c3b:	eb 25                	jmp    100c62 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c44:	83 f8 02             	cmp    $0x2,%eax
  100c47:	76 9f                	jbe    100be8 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c49:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4c:	83 ec 08             	sub    $0x8,%esp
  100c4f:	50                   	push   %eax
  100c50:	68 d3 60 10 00       	push   $0x1060d3
  100c55:	e8 0d f6 ff ff       	call   100267 <cprintf>
  100c5a:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c62:	c9                   	leave  
  100c63:	c3                   	ret    

00100c64 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c64:	55                   	push   %ebp
  100c65:	89 e5                	mov    %esp,%ebp
  100c67:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c6a:	83 ec 0c             	sub    $0xc,%esp
  100c6d:	68 ec 60 10 00       	push   $0x1060ec
  100c72:	e8 f0 f5 ff ff       	call   100267 <cprintf>
  100c77:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c7a:	83 ec 0c             	sub    $0xc,%esp
  100c7d:	68 14 61 10 00       	push   $0x106114
  100c82:	e8 e0 f5 ff ff       	call   100267 <cprintf>
  100c87:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c8e:	74 0e                	je     100c9e <kmonitor+0x3a>
        print_trapframe(tf);
  100c90:	83 ec 0c             	sub    $0xc,%esp
  100c93:	ff 75 08             	pushl  0x8(%ebp)
  100c96:	e8 9e 0d 00 00       	call   101a39 <print_trapframe>
  100c9b:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c9e:	83 ec 0c             	sub    $0xc,%esp
  100ca1:	68 39 61 10 00       	push   $0x106139
  100ca6:	e8 60 f6 ff ff       	call   10030b <readline>
  100cab:	83 c4 10             	add    $0x10,%esp
  100cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb5:	74 e7                	je     100c9e <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cb7:	83 ec 08             	sub    $0x8,%esp
  100cba:	ff 75 08             	pushl  0x8(%ebp)
  100cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc0:	e8 ef fe ff ff       	call   100bb4 <runcmd>
  100cc5:	83 c4 10             	add    $0x10,%esp
  100cc8:	85 c0                	test   %eax,%eax
  100cca:	78 02                	js     100cce <kmonitor+0x6a>
                break;
            }
        }
    }
  100ccc:	eb d0                	jmp    100c9e <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cce:	90                   	nop
            }
        }
    }
}
  100ccf:	90                   	nop
  100cd0:	c9                   	leave  
  100cd1:	c3                   	ret    

00100cd2 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd2:	55                   	push   %ebp
  100cd3:	89 e5                	mov    %esp,%ebp
  100cd5:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cdf:	eb 3c                	jmp    100d1d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce4:	89 d0                	mov    %edx,%eax
  100ce6:	01 c0                	add    %eax,%eax
  100ce8:	01 d0                	add    %edx,%eax
  100cea:	c1 e0 02             	shl    $0x2,%eax
  100ced:	05 24 70 11 00       	add    $0x117024,%eax
  100cf2:	8b 08                	mov    (%eax),%ecx
  100cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf7:	89 d0                	mov    %edx,%eax
  100cf9:	01 c0                	add    %eax,%eax
  100cfb:	01 d0                	add    %edx,%eax
  100cfd:	c1 e0 02             	shl    $0x2,%eax
  100d00:	05 20 70 11 00       	add    $0x117020,%eax
  100d05:	8b 00                	mov    (%eax),%eax
  100d07:	83 ec 04             	sub    $0x4,%esp
  100d0a:	51                   	push   %ecx
  100d0b:	50                   	push   %eax
  100d0c:	68 3d 61 10 00       	push   $0x10613d
  100d11:	e8 51 f5 ff ff       	call   100267 <cprintf>
  100d16:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d20:	83 f8 02             	cmp    $0x2,%eax
  100d23:	76 bc                	jbe    100ce1 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2a:	c9                   	leave  
  100d2b:	c3                   	ret    

00100d2c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d2c:	55                   	push   %ebp
  100d2d:	89 e5                	mov    %esp,%ebp
  100d2f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d32:	e8 ba fb ff ff       	call   1008f1 <print_kerninfo>
    return 0;
  100d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3c:	c9                   	leave  
  100d3d:	c3                   	ret    

00100d3e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d3e:	55                   	push   %ebp
  100d3f:	89 e5                	mov    %esp,%ebp
  100d41:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d44:	e8 f2 fc ff ff       	call   100a3b <print_stackframe>
    return 0;
  100d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4e:	c9                   	leave  
  100d4f:	c3                   	ret    

00100d50 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d50:	55                   	push   %ebp
  100d51:	89 e5                	mov    %esp,%ebp
  100d53:	83 ec 18             	sub    $0x18,%esp
  100d56:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d5c:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d60:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d68:	ee                   	out    %al,(%dx)
  100d69:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d6f:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d73:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d77:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
  100d7c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d82:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d8f:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d96:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d99:	83 ec 0c             	sub    $0xc,%esp
  100d9c:	68 46 61 10 00       	push   $0x106146
  100da1:	e8 c1 f4 ff ff       	call   100267 <cprintf>
  100da6:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100da9:	83 ec 0c             	sub    $0xc,%esp
  100dac:	6a 00                	push   $0x0
  100dae:	e8 3b 09 00 00       	call   1016ee <pic_enable>
  100db3:	83 c4 10             	add    $0x10,%esp
}
  100db6:	90                   	nop
  100db7:	c9                   	leave  
  100db8:	c3                   	ret    

00100db9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100db9:	55                   	push   %ebp
  100dba:	89 e5                	mov    %esp,%ebp
  100dbc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dbf:	9c                   	pushf  
  100dc0:	58                   	pop    %eax
  100dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dc7:	25 00 02 00 00       	and    $0x200,%eax
  100dcc:	85 c0                	test   %eax,%eax
  100dce:	74 0c                	je     100ddc <__intr_save+0x23>
        intr_disable();
  100dd0:	e8 8a 0a 00 00       	call   10185f <intr_disable>
        return 1;
  100dd5:	b8 01 00 00 00       	mov    $0x1,%eax
  100dda:	eb 05                	jmp    100de1 <__intr_save+0x28>
    }
    return 0;
  100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de1:	c9                   	leave  
  100de2:	c3                   	ret    

00100de3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100de3:	55                   	push   %ebp
  100de4:	89 e5                	mov    %esp,%ebp
  100de6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ded:	74 05                	je     100df4 <__intr_restore+0x11>
        intr_enable();
  100def:	e8 64 0a 00 00       	call   101858 <intr_enable>
    }
}
  100df4:	90                   	nop
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100df7:	55                   	push   %ebp
  100df8:	89 e5                	mov    %esp,%ebp
  100dfa:	83 ec 10             	sub    $0x10,%esp
  100dfd:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e03:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e07:	89 c2                	mov    %eax,%edx
  100e09:	ec                   	in     (%dx),%al
  100e0a:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e0d:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e13:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e17:	89 c2                	mov    %eax,%edx
  100e19:	ec                   	in     (%dx),%al
  100e1a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e1d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e23:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e27:	89 c2                	mov    %eax,%edx
  100e29:	ec                   	in     (%dx),%al
  100e2a:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e2d:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e33:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e37:	89 c2                	mov    %eax,%edx
  100e39:	ec                   	in     (%dx),%al
  100e3a:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e3d:	90                   	nop
  100e3e:	c9                   	leave  
  100e3f:	c3                   	ret    

00100e40 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e40:	55                   	push   %ebp
  100e41:	89 e5                	mov    %esp,%ebp
  100e43:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e46:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e50:	0f b7 00             	movzwl (%eax),%eax
  100e53:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e62:	0f b7 00             	movzwl (%eax),%eax
  100e65:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e69:	74 12                	je     100e7d <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e6b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e72:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e79:	b4 03 
  100e7b:	eb 13                	jmp    100e90 <cga_init+0x50>
    } else {
        *cp = was;
  100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e80:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e84:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e87:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e8e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e90:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e97:	0f b7 c0             	movzwl %ax,%eax
  100e9a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e9e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ea2:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100ea6:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100eaa:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eab:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eb2:	83 c0 01             	add    $0x1,%eax
  100eb5:	0f b7 c0             	movzwl %ax,%eax
  100eb8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ebc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ec0:	89 c2                	mov    %eax,%edx
  100ec2:	ec                   	in     (%dx),%al
  100ec3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ec6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100eca:	0f b6 c0             	movzbl %al,%eax
  100ecd:	c1 e0 08             	shl    $0x8,%eax
  100ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ed3:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eda:	0f b7 c0             	movzwl %ax,%eax
  100edd:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ee1:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100ee9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100eed:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eee:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ef5:	83 c0 01             	add    $0x1,%eax
  100ef8:	0f b7 c0             	movzwl %ax,%eax
  100efb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eff:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f03:	89 c2                	mov    %eax,%edx
  100f05:	ec                   	in     (%dx),%al
  100f06:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0d:	0f b6 c0             	movzbl %al,%eax
  100f10:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f16:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f1e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f24:	90                   	nop
  100f25:	c9                   	leave  
  100f26:	c3                   	ret    

00100f27 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f27:	55                   	push   %ebp
  100f28:	89 e5                	mov    %esp,%ebp
  100f2a:	83 ec 28             	sub    $0x28,%esp
  100f2d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f33:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f37:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f3b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f46:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f4a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f4e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f59:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f5d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f61:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f6c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f70:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f74:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f7f:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f83:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f87:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8b:	ee                   	out    %al,(%dx)
  100f8c:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f92:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f96:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f9a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f9e:	ee                   	out    %al,(%dx)
  100f9f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa5:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fa9:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb1:	ee                   	out    %al,(%dx)
  100fb2:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fb8:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fbc:	89 c2                	mov    %eax,%edx
  100fbe:	ec                   	in     (%dx),%al
  100fbf:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fc2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc6:	3c ff                	cmp    $0xff,%al
  100fc8:	0f 95 c0             	setne  %al
  100fcb:	0f b6 c0             	movzbl %al,%eax
  100fce:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fd3:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fd9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fdd:	89 c2                	mov    %eax,%edx
  100fdf:	ec                   	in     (%dx),%al
  100fe0:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100fe3:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100fe9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fed:	89 c2                	mov    %eax,%edx
  100fef:	ec                   	in     (%dx),%al
  100ff0:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff3:	a1 88 7e 11 00       	mov    0x117e88,%eax
  100ff8:	85 c0                	test   %eax,%eax
  100ffa:	74 0d                	je     101009 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100ffc:	83 ec 0c             	sub    $0xc,%esp
  100fff:	6a 04                	push   $0x4
  101001:	e8 e8 06 00 00       	call   1016ee <pic_enable>
  101006:	83 c4 10             	add    $0x10,%esp
    }
}
  101009:	90                   	nop
  10100a:	c9                   	leave  
  10100b:	c3                   	ret    

0010100c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100c:	55                   	push   %ebp
  10100d:	89 e5                	mov    %esp,%ebp
  10100f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101019:	eb 09                	jmp    101024 <lpt_putc_sub+0x18>
        delay();
  10101b:	e8 d7 fd ff ff       	call   100df7 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101020:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101024:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10102a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10102e:	89 c2                	mov    %eax,%edx
  101030:	ec                   	in     (%dx),%al
  101031:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  101034:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101038:	84 c0                	test   %al,%al
  10103a:	78 09                	js     101045 <lpt_putc_sub+0x39>
  10103c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101043:	7e d6                	jle    10101b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101045:	8b 45 08             	mov    0x8(%ebp),%eax
  101048:	0f b6 c0             	movzbl %al,%eax
  10104b:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101051:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101054:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  101058:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10105c:	ee                   	out    %al,(%dx)
  10105d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101063:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101067:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10106f:	ee                   	out    %al,(%dx)
  101070:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101076:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10107a:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10107e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101082:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101083:	90                   	nop
  101084:	c9                   	leave  
  101085:	c3                   	ret    

00101086 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101086:	55                   	push   %ebp
  101087:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101089:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10108d:	74 0d                	je     10109c <lpt_putc+0x16>
        lpt_putc_sub(c);
  10108f:	ff 75 08             	pushl  0x8(%ebp)
  101092:	e8 75 ff ff ff       	call   10100c <lpt_putc_sub>
  101097:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10109a:	eb 1e                	jmp    1010ba <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10109c:	6a 08                	push   $0x8
  10109e:	e8 69 ff ff ff       	call   10100c <lpt_putc_sub>
  1010a3:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010a6:	6a 20                	push   $0x20
  1010a8:	e8 5f ff ff ff       	call   10100c <lpt_putc_sub>
  1010ad:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010b0:	6a 08                	push   $0x8
  1010b2:	e8 55 ff ff ff       	call   10100c <lpt_putc_sub>
  1010b7:	83 c4 04             	add    $0x4,%esp
    }
}
  1010ba:	90                   	nop
  1010bb:	c9                   	leave  
  1010bc:	c3                   	ret    

001010bd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010bd:	55                   	push   %ebp
  1010be:	89 e5                	mov    %esp,%ebp
  1010c0:	53                   	push   %ebx
  1010c1:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c7:	b0 00                	mov    $0x0,%al
  1010c9:	85 c0                	test   %eax,%eax
  1010cb:	75 07                	jne    1010d4 <cga_putc+0x17>
        c |= 0x0700;
  1010cd:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d7:	0f b6 c0             	movzbl %al,%eax
  1010da:	83 f8 0a             	cmp    $0xa,%eax
  1010dd:	74 4e                	je     10112d <cga_putc+0x70>
  1010df:	83 f8 0d             	cmp    $0xd,%eax
  1010e2:	74 59                	je     10113d <cga_putc+0x80>
  1010e4:	83 f8 08             	cmp    $0x8,%eax
  1010e7:	0f 85 8a 00 00 00    	jne    101177 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010ed:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010f4:	66 85 c0             	test   %ax,%ax
  1010f7:	0f 84 a0 00 00 00    	je     10119d <cga_putc+0xe0>
            crt_pos --;
  1010fd:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101104:	83 e8 01             	sub    $0x1,%eax
  101107:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10110d:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101112:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101119:	0f b7 d2             	movzwl %dx,%edx
  10111c:	01 d2                	add    %edx,%edx
  10111e:	01 d0                	add    %edx,%eax
  101120:	8b 55 08             	mov    0x8(%ebp),%edx
  101123:	b2 00                	mov    $0x0,%dl
  101125:	83 ca 20             	or     $0x20,%edx
  101128:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10112b:	eb 70                	jmp    10119d <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  10112d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101134:	83 c0 50             	add    $0x50,%eax
  101137:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10113d:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101144:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10114b:	0f b7 c1             	movzwl %cx,%eax
  10114e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101154:	c1 e8 10             	shr    $0x10,%eax
  101157:	89 c2                	mov    %eax,%edx
  101159:	66 c1 ea 06          	shr    $0x6,%dx
  10115d:	89 d0                	mov    %edx,%eax
  10115f:	c1 e0 02             	shl    $0x2,%eax
  101162:	01 d0                	add    %edx,%eax
  101164:	c1 e0 04             	shl    $0x4,%eax
  101167:	29 c1                	sub    %eax,%ecx
  101169:	89 ca                	mov    %ecx,%edx
  10116b:	89 d8                	mov    %ebx,%eax
  10116d:	29 d0                	sub    %edx,%eax
  10116f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  101175:	eb 27                	jmp    10119e <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101177:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  10117d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101184:	8d 50 01             	lea    0x1(%eax),%edx
  101187:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  10118e:	0f b7 c0             	movzwl %ax,%eax
  101191:	01 c0                	add    %eax,%eax
  101193:	01 c8                	add    %ecx,%eax
  101195:	8b 55 08             	mov    0x8(%ebp),%edx
  101198:	66 89 10             	mov    %dx,(%eax)
        break;
  10119b:	eb 01                	jmp    10119e <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10119d:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10119e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011a5:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011a9:	76 59                	jbe    101204 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011ab:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011b0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011b6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011bb:	83 ec 04             	sub    $0x4,%esp
  1011be:	68 00 0f 00 00       	push   $0xf00
  1011c3:	52                   	push   %edx
  1011c4:	50                   	push   %eax
  1011c5:	e8 0c 45 00 00       	call   1056d6 <memmove>
  1011ca:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011cd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011d4:	eb 15                	jmp    1011eb <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011de:	01 d2                	add    %edx,%edx
  1011e0:	01 d0                	add    %edx,%eax
  1011e2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011eb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011f2:	7e e2                	jle    1011d6 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011f4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011fb:	83 e8 50             	sub    $0x50,%eax
  1011fe:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101204:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10120b:	0f b7 c0             	movzwl %ax,%eax
  10120e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101212:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  101216:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10121a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10121e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10121f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101226:	66 c1 e8 08          	shr    $0x8,%ax
  10122a:	0f b6 c0             	movzbl %al,%eax
  10122d:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101234:	83 c2 01             	add    $0x1,%edx
  101237:	0f b7 d2             	movzwl %dx,%edx
  10123a:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10123e:	88 45 e9             	mov    %al,-0x17(%ebp)
  101241:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101245:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101249:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10124a:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101251:	0f b7 c0             	movzwl %ax,%eax
  101254:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101258:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10125c:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101260:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101264:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101265:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10126c:	0f b6 c0             	movzbl %al,%eax
  10126f:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101276:	83 c2 01             	add    $0x1,%edx
  101279:	0f b7 d2             	movzwl %dx,%edx
  10127c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101280:	88 45 eb             	mov    %al,-0x15(%ebp)
  101283:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101287:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10128b:	ee                   	out    %al,(%dx)
}
  10128c:	90                   	nop
  10128d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101290:	c9                   	leave  
  101291:	c3                   	ret    

00101292 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101292:	55                   	push   %ebp
  101293:	89 e5                	mov    %esp,%ebp
  101295:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10129f:	eb 09                	jmp    1012aa <serial_putc_sub+0x18>
        delay();
  1012a1:	e8 51 fb ff ff       	call   100df7 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012aa:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012b0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012b4:	89 c2                	mov    %eax,%edx
  1012b6:	ec                   	in     (%dx),%al
  1012b7:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012ba:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012be:	0f b6 c0             	movzbl %al,%eax
  1012c1:	83 e0 20             	and    $0x20,%eax
  1012c4:	85 c0                	test   %eax,%eax
  1012c6:	75 09                	jne    1012d1 <serial_putc_sub+0x3f>
  1012c8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012cf:	7e d0                	jle    1012a1 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d4:	0f b6 c0             	movzbl %al,%eax
  1012d7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012dd:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012e0:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012e8:	ee                   	out    %al,(%dx)
}
  1012e9:	90                   	nop
  1012ea:	c9                   	leave  
  1012eb:	c3                   	ret    

001012ec <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012ec:	55                   	push   %ebp
  1012ed:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012ef:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012f3:	74 0d                	je     101302 <serial_putc+0x16>
        serial_putc_sub(c);
  1012f5:	ff 75 08             	pushl  0x8(%ebp)
  1012f8:	e8 95 ff ff ff       	call   101292 <serial_putc_sub>
  1012fd:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101300:	eb 1e                	jmp    101320 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101302:	6a 08                	push   $0x8
  101304:	e8 89 ff ff ff       	call   101292 <serial_putc_sub>
  101309:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10130c:	6a 20                	push   $0x20
  10130e:	e8 7f ff ff ff       	call   101292 <serial_putc_sub>
  101313:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101316:	6a 08                	push   $0x8
  101318:	e8 75 ff ff ff       	call   101292 <serial_putc_sub>
  10131d:	83 c4 04             	add    $0x4,%esp
    }
}
  101320:	90                   	nop
  101321:	c9                   	leave  
  101322:	c3                   	ret    

00101323 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101323:	55                   	push   %ebp
  101324:	89 e5                	mov    %esp,%ebp
  101326:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101329:	eb 33                	jmp    10135e <cons_intr+0x3b>
        if (c != 0) {
  10132b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10132f:	74 2d                	je     10135e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101331:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101336:	8d 50 01             	lea    0x1(%eax),%edx
  101339:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101342:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101348:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10134d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101352:	75 0a                	jne    10135e <cons_intr+0x3b>
                cons.wpos = 0;
  101354:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10135b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10135e:	8b 45 08             	mov    0x8(%ebp),%eax
  101361:	ff d0                	call   *%eax
  101363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101366:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10136a:	75 bf                	jne    10132b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10136c:	90                   	nop
  10136d:	c9                   	leave  
  10136e:	c3                   	ret    

0010136f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10136f:	55                   	push   %ebp
  101370:	89 e5                	mov    %esp,%ebp
  101372:	83 ec 10             	sub    $0x10,%esp
  101375:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10137b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10137f:	89 c2                	mov    %eax,%edx
  101381:	ec                   	in     (%dx),%al
  101382:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101385:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101389:	0f b6 c0             	movzbl %al,%eax
  10138c:	83 e0 01             	and    $0x1,%eax
  10138f:	85 c0                	test   %eax,%eax
  101391:	75 07                	jne    10139a <serial_proc_data+0x2b>
        return -1;
  101393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101398:	eb 2a                	jmp    1013c4 <serial_proc_data+0x55>
  10139a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a4:	89 c2                	mov    %eax,%edx
  1013a6:	ec                   	in     (%dx),%al
  1013a7:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013aa:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ae:	0f b6 c0             	movzbl %al,%eax
  1013b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013b4:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013b8:	75 07                	jne    1013c1 <serial_proc_data+0x52>
        c = '\b';
  1013ba:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013c4:	c9                   	leave  
  1013c5:	c3                   	ret    

001013c6 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013c6:	55                   	push   %ebp
  1013c7:	89 e5                	mov    %esp,%ebp
  1013c9:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013cc:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013d1:	85 c0                	test   %eax,%eax
  1013d3:	74 10                	je     1013e5 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013d5:	83 ec 0c             	sub    $0xc,%esp
  1013d8:	68 6f 13 10 00       	push   $0x10136f
  1013dd:	e8 41 ff ff ff       	call   101323 <cons_intr>
  1013e2:	83 c4 10             	add    $0x10,%esp
    }
}
  1013e5:	90                   	nop
  1013e6:	c9                   	leave  
  1013e7:	c3                   	ret    

001013e8 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013e8:	55                   	push   %ebp
  1013e9:	89 e5                	mov    %esp,%ebp
  1013eb:	83 ec 18             	sub    $0x18,%esp
  1013ee:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013f4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f8:	89 c2                	mov    %eax,%edx
  1013fa:	ec                   	in     (%dx),%al
  1013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101402:	0f b6 c0             	movzbl %al,%eax
  101405:	83 e0 01             	and    $0x1,%eax
  101408:	85 c0                	test   %eax,%eax
  10140a:	75 0a                	jne    101416 <kbd_proc_data+0x2e>
        return -1;
  10140c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101411:	e9 5d 01 00 00       	jmp    101573 <kbd_proc_data+0x18b>
  101416:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101420:	89 c2                	mov    %eax,%edx
  101422:	ec                   	in     (%dx),%al
  101423:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  101426:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10142a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10142d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101431:	75 17                	jne    10144a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101433:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101438:	83 c8 40             	or     $0x40,%eax
  10143b:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101440:	b8 00 00 00 00       	mov    $0x0,%eax
  101445:	e9 29 01 00 00       	jmp    101573 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10144a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144e:	84 c0                	test   %al,%al
  101450:	79 47                	jns    101499 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101452:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101457:	83 e0 40             	and    $0x40,%eax
  10145a:	85 c0                	test   %eax,%eax
  10145c:	75 09                	jne    101467 <kbd_proc_data+0x7f>
  10145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101462:	83 e0 7f             	and    $0x7f,%eax
  101465:	eb 04                	jmp    10146b <kbd_proc_data+0x83>
  101467:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10146e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101472:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101479:	83 c8 40             	or     $0x40,%eax
  10147c:	0f b6 c0             	movzbl %al,%eax
  10147f:	f7 d0                	not    %eax
  101481:	89 c2                	mov    %eax,%edx
  101483:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101488:	21 d0                	and    %edx,%eax
  10148a:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10148f:	b8 00 00 00 00       	mov    $0x0,%eax
  101494:	e9 da 00 00 00       	jmp    101573 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101499:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10149e:	83 e0 40             	and    $0x40,%eax
  1014a1:	85 c0                	test   %eax,%eax
  1014a3:	74 11                	je     1014b6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014a5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014a9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ae:	83 e0 bf             	and    $0xffffffbf,%eax
  1014b1:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ba:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014c1:	0f b6 d0             	movzbl %al,%edx
  1014c4:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c9:	09 d0                	or     %edx,%eax
  1014cb:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d4:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014db:	0f b6 d0             	movzbl %al,%edx
  1014de:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e3:	31 d0                	xor    %edx,%eax
  1014e5:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ea:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ef:	83 e0 03             	and    $0x3,%eax
  1014f2:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  1014f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fd:	01 d0                	add    %edx,%eax
  1014ff:	0f b6 00             	movzbl (%eax),%eax
  101502:	0f b6 c0             	movzbl %al,%eax
  101505:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101508:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10150d:	83 e0 08             	and    $0x8,%eax
  101510:	85 c0                	test   %eax,%eax
  101512:	74 22                	je     101536 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101514:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101518:	7e 0c                	jle    101526 <kbd_proc_data+0x13e>
  10151a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10151e:	7f 06                	jg     101526 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101520:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101524:	eb 10                	jmp    101536 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101526:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10152a:	7e 0a                	jle    101536 <kbd_proc_data+0x14e>
  10152c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101530:	7f 04                	jg     101536 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101532:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	f7 d0                	not    %eax
  10153d:	83 e0 06             	and    $0x6,%eax
  101540:	85 c0                	test   %eax,%eax
  101542:	75 2c                	jne    101570 <kbd_proc_data+0x188>
  101544:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10154b:	75 23                	jne    101570 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10154d:	83 ec 0c             	sub    $0xc,%esp
  101550:	68 61 61 10 00       	push   $0x106161
  101555:	e8 0d ed ff ff       	call   100267 <cprintf>
  10155a:	83 c4 10             	add    $0x10,%esp
  10155d:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101563:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101567:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10156b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10156f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101570:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101573:	c9                   	leave  
  101574:	c3                   	ret    

00101575 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101575:	55                   	push   %ebp
  101576:	89 e5                	mov    %esp,%ebp
  101578:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10157b:	83 ec 0c             	sub    $0xc,%esp
  10157e:	68 e8 13 10 00       	push   $0x1013e8
  101583:	e8 9b fd ff ff       	call   101323 <cons_intr>
  101588:	83 c4 10             	add    $0x10,%esp
}
  10158b:	90                   	nop
  10158c:	c9                   	leave  
  10158d:	c3                   	ret    

0010158e <kbd_init>:

static void
kbd_init(void) {
  10158e:	55                   	push   %ebp
  10158f:	89 e5                	mov    %esp,%ebp
  101591:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101594:	e8 dc ff ff ff       	call   101575 <kbd_intr>
    pic_enable(IRQ_KBD);
  101599:	83 ec 0c             	sub    $0xc,%esp
  10159c:	6a 01                	push   $0x1
  10159e:	e8 4b 01 00 00       	call   1016ee <pic_enable>
  1015a3:	83 c4 10             	add    $0x10,%esp
}
  1015a6:	90                   	nop
  1015a7:	c9                   	leave  
  1015a8:	c3                   	ret    

001015a9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015a9:	55                   	push   %ebp
  1015aa:	89 e5                	mov    %esp,%ebp
  1015ac:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015af:	e8 8c f8 ff ff       	call   100e40 <cga_init>
    serial_init();
  1015b4:	e8 6e f9 ff ff       	call   100f27 <serial_init>
    kbd_init();
  1015b9:	e8 d0 ff ff ff       	call   10158e <kbd_init>
    if (!serial_exists) {
  1015be:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015c3:	85 c0                	test   %eax,%eax
  1015c5:	75 10                	jne    1015d7 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015c7:	83 ec 0c             	sub    $0xc,%esp
  1015ca:	68 6d 61 10 00       	push   $0x10616d
  1015cf:	e8 93 ec ff ff       	call   100267 <cprintf>
  1015d4:	83 c4 10             	add    $0x10,%esp
    }
}
  1015d7:	90                   	nop
  1015d8:	c9                   	leave  
  1015d9:	c3                   	ret    

001015da <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015da:	55                   	push   %ebp
  1015db:	89 e5                	mov    %esp,%ebp
  1015dd:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015e0:	e8 d4 f7 ff ff       	call   100db9 <__intr_save>
  1015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015e8:	83 ec 0c             	sub    $0xc,%esp
  1015eb:	ff 75 08             	pushl  0x8(%ebp)
  1015ee:	e8 93 fa ff ff       	call   101086 <lpt_putc>
  1015f3:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  1015f6:	83 ec 0c             	sub    $0xc,%esp
  1015f9:	ff 75 08             	pushl  0x8(%ebp)
  1015fc:	e8 bc fa ff ff       	call   1010bd <cga_putc>
  101601:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  101604:	83 ec 0c             	sub    $0xc,%esp
  101607:	ff 75 08             	pushl  0x8(%ebp)
  10160a:	e8 dd fc ff ff       	call   1012ec <serial_putc>
  10160f:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  101612:	83 ec 0c             	sub    $0xc,%esp
  101615:	ff 75 f4             	pushl  -0xc(%ebp)
  101618:	e8 c6 f7 ff ff       	call   100de3 <__intr_restore>
  10161d:	83 c4 10             	add    $0x10,%esp
}
  101620:	90                   	nop
  101621:	c9                   	leave  
  101622:	c3                   	ret    

00101623 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101623:	55                   	push   %ebp
  101624:	89 e5                	mov    %esp,%ebp
  101626:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101630:	e8 84 f7 ff ff       	call   100db9 <__intr_save>
  101635:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101638:	e8 89 fd ff ff       	call   1013c6 <serial_intr>
        kbd_intr();
  10163d:	e8 33 ff ff ff       	call   101575 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101642:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101648:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10164d:	39 c2                	cmp    %eax,%edx
  10164f:	74 31                	je     101682 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101651:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101656:	8d 50 01             	lea    0x1(%eax),%edx
  101659:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10165f:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101666:	0f b6 c0             	movzbl %al,%eax
  101669:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10166c:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101671:	3d 00 02 00 00       	cmp    $0x200,%eax
  101676:	75 0a                	jne    101682 <cons_getc+0x5f>
                cons.rpos = 0;
  101678:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10167f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101682:	83 ec 0c             	sub    $0xc,%esp
  101685:	ff 75 f0             	pushl  -0x10(%ebp)
  101688:	e8 56 f7 ff ff       	call   100de3 <__intr_restore>
  10168d:	83 c4 10             	add    $0x10,%esp
    return c;
  101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101693:	c9                   	leave  
  101694:	c3                   	ret    

00101695 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101695:	55                   	push   %ebp
  101696:	89 e5                	mov    %esp,%ebp
  101698:	83 ec 14             	sub    $0x14,%esp
  10169b:	8b 45 08             	mov    0x8(%ebp),%eax
  10169e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016a6:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016ac:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016b1:	85 c0                	test   %eax,%eax
  1016b3:	74 36                	je     1016eb <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016b5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016b9:	0f b6 c0             	movzbl %al,%eax
  1016bc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c2:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016c5:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016c9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016cd:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d2:	66 c1 e8 08          	shr    $0x8,%ax
  1016d6:	0f b6 c0             	movzbl %al,%eax
  1016d9:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016df:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016e2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016e6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
    }
}
  1016eb:	90                   	nop
  1016ec:	c9                   	leave  
  1016ed:	c3                   	ret    

001016ee <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016ee:	55                   	push   %ebp
  1016ef:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f4:	ba 01 00 00 00       	mov    $0x1,%edx
  1016f9:	89 c1                	mov    %eax,%ecx
  1016fb:	d3 e2                	shl    %cl,%edx
  1016fd:	89 d0                	mov    %edx,%eax
  1016ff:	f7 d0                	not    %eax
  101701:	89 c2                	mov    %eax,%edx
  101703:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10170a:	21 d0                	and    %edx,%eax
  10170c:	0f b7 c0             	movzwl %ax,%eax
  10170f:	50                   	push   %eax
  101710:	e8 80 ff ff ff       	call   101695 <pic_setmask>
  101715:	83 c4 04             	add    $0x4,%esp
}
  101718:	90                   	nop
  101719:	c9                   	leave  
  10171a:	c3                   	ret    

0010171b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10171b:	55                   	push   %ebp
  10171c:	89 e5                	mov    %esp,%ebp
  10171e:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101721:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101728:	00 00 00 
  10172b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101731:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  101735:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101739:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10173d:	ee                   	out    %al,(%dx)
  10173e:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101744:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  101748:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  10174c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101750:	ee                   	out    %al,(%dx)
  101751:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  101757:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  10175b:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  10175f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101763:	ee                   	out    %al,(%dx)
  101764:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  10176a:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  10176e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101772:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101776:	ee                   	out    %al,(%dx)
  101777:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  10177d:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101781:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101785:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101789:	ee                   	out    %al,(%dx)
  10178a:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101790:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101794:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  101798:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10179c:	ee                   	out    %al,(%dx)
  10179d:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017a3:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017a7:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017ab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017af:	ee                   	out    %al,(%dx)
  1017b0:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017b6:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017ba:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017be:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017c2:	ee                   	out    %al,(%dx)
  1017c3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017c9:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017cd:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017d5:	ee                   	out    %al,(%dx)
  1017d6:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017dc:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017e0:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017e4:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017e8:	ee                   	out    %al,(%dx)
  1017e9:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017ef:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1017f3:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1017f7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017fb:	ee                   	out    %al,(%dx)
  1017fc:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101802:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101806:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10180a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10180e:	ee                   	out    %al,(%dx)
  10180f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101815:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101819:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10181d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101821:	ee                   	out    %al,(%dx)
  101822:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101828:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10182c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101830:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  101834:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101835:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10183c:	66 83 f8 ff          	cmp    $0xffff,%ax
  101840:	74 13                	je     101855 <pic_init+0x13a>
        pic_setmask(irq_mask);
  101842:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101849:	0f b7 c0             	movzwl %ax,%eax
  10184c:	50                   	push   %eax
  10184d:	e8 43 fe ff ff       	call   101695 <pic_setmask>
  101852:	83 c4 04             	add    $0x4,%esp
    }
}
  101855:	90                   	nop
  101856:	c9                   	leave  
  101857:	c3                   	ret    

00101858 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101858:	55                   	push   %ebp
  101859:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  10185b:	fb                   	sti    
    sti();
}
  10185c:	90                   	nop
  10185d:	5d                   	pop    %ebp
  10185e:	c3                   	ret    

0010185f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10185f:	55                   	push   %ebp
  101860:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101862:	fa                   	cli    
    cli();
}
  101863:	90                   	nop
  101864:	5d                   	pop    %ebp
  101865:	c3                   	ret    

00101866 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101866:	55                   	push   %ebp
  101867:	89 e5                	mov    %esp,%ebp
  101869:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10186c:	83 ec 08             	sub    $0x8,%esp
  10186f:	6a 64                	push   $0x64
  101871:	68 a0 61 10 00       	push   $0x1061a0
  101876:	e8 ec e9 ff ff       	call   100267 <cprintf>
  10187b:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10187e:	90                   	nop
  10187f:	c9                   	leave  
  101880:	c3                   	ret    

00101881 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101881:	55                   	push   %ebp
  101882:	89 e5                	mov    %esp,%ebp
  101884:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
  101887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10188e:	e9 c3 00 00 00       	jmp    101956 <idt_init+0xd5>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
  101893:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101896:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10189d:	89 c2                	mov    %eax,%edx
  10189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a2:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018a9:	00 
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018b4:	00 08 00 
  1018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ba:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018c1:	00 
  1018c2:	83 e2 e0             	and    $0xffffffe0,%edx
  1018c5:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cf:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018d6:	00 
  1018d7:	83 e2 1f             	and    $0x1f,%edx
  1018da:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e4:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018eb:	00 
  1018ec:	83 e2 f0             	and    $0xfffffff0,%edx
  1018ef:	83 ca 0e             	or     $0xe,%edx
  1018f2:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fc:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101903:	00 
  101904:	83 e2 ef             	and    $0xffffffef,%edx
  101907:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101911:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101918:	00 
  101919:	83 e2 9f             	and    $0xffffff9f,%edx
  10191c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101926:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10192d:	00 
  10192e:	83 ca 80             	or     $0xffffff80,%edx
  101931:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101938:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193b:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101942:	c1 e8 10             	shr    $0x10,%eax
  101945:	89 c2                	mov    %eax,%edx
  101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194a:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101951:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
  101952:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101956:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10195d:	0f 8e 30 ff ff ff    	jle    101893 <idt_init+0x12>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
    }

    SETGATE( idt[ T_SWITCH_TOK ], 0, GD_KTEXT, __vectors[ T_SWITCH_TOK ], DPL_USER ); 
  101963:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101968:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10196e:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101975:	08 00 
  101977:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10197e:	83 e0 e0             	and    $0xffffffe0,%eax
  101981:	a2 8c 84 11 00       	mov    %al,0x11848c
  101986:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10198d:	83 e0 1f             	and    $0x1f,%eax
  101990:	a2 8c 84 11 00       	mov    %al,0x11848c
  101995:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  10199c:	83 e0 f0             	and    $0xfffffff0,%eax
  10199f:	83 c8 0e             	or     $0xe,%eax
  1019a2:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019a7:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ae:	83 e0 ef             	and    $0xffffffef,%eax
  1019b1:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019b6:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019bd:	83 c8 60             	or     $0x60,%eax
  1019c0:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c5:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019cc:	83 c8 80             	or     $0xffffff80,%eax
  1019cf:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d4:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019d9:	c1 e8 10             	shr    $0x10,%eax
  1019dc:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019e2:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019ec:	0f 01 18             	lidtl  (%eax)
    lidt( &idt_pd );
}
  1019ef:	90                   	nop
  1019f0:	c9                   	leave  
  1019f1:	c3                   	ret    

001019f2 <trapname>:

static const char *
trapname(int trapno) {
  1019f2:	55                   	push   %ebp
  1019f3:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f8:	83 f8 13             	cmp    $0x13,%eax
  1019fb:	77 0c                	ja     101a09 <trapname+0x17>
        return excnames[trapno];
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	8b 04 85 00 65 10 00 	mov    0x106500(,%eax,4),%eax
  101a07:	eb 18                	jmp    101a21 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a09:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a0d:	7e 0d                	jle    101a1c <trapname+0x2a>
  101a0f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a13:	7f 07                	jg     101a1c <trapname+0x2a>
        return "Hardware Interrupt";
  101a15:	b8 aa 61 10 00       	mov    $0x1061aa,%eax
  101a1a:	eb 05                	jmp    101a21 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a1c:	b8 bd 61 10 00       	mov    $0x1061bd,%eax
}
  101a21:	5d                   	pop    %ebp
  101a22:	c3                   	ret    

00101a23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a23:	55                   	push   %ebp
  101a24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a2d:	66 83 f8 08          	cmp    $0x8,%ax
  101a31:	0f 94 c0             	sete   %al
  101a34:	0f b6 c0             	movzbl %al,%eax
}
  101a37:	5d                   	pop    %ebp
  101a38:	c3                   	ret    

00101a39 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a39:	55                   	push   %ebp
  101a3a:	89 e5                	mov    %esp,%ebp
  101a3c:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a3f:	83 ec 08             	sub    $0x8,%esp
  101a42:	ff 75 08             	pushl  0x8(%ebp)
  101a45:	68 fe 61 10 00       	push   $0x1061fe
  101a4a:	e8 18 e8 ff ff       	call   100267 <cprintf>
  101a4f:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	83 ec 0c             	sub    $0xc,%esp
  101a58:	50                   	push   %eax
  101a59:	e8 b8 01 00 00       	call   101c16 <print_regs>
  101a5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a68:	0f b7 c0             	movzwl %ax,%eax
  101a6b:	83 ec 08             	sub    $0x8,%esp
  101a6e:	50                   	push   %eax
  101a6f:	68 0f 62 10 00       	push   $0x10620f
  101a74:	e8 ee e7 ff ff       	call   100267 <cprintf>
  101a79:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a83:	0f b7 c0             	movzwl %ax,%eax
  101a86:	83 ec 08             	sub    $0x8,%esp
  101a89:	50                   	push   %eax
  101a8a:	68 22 62 10 00       	push   $0x106222
  101a8f:	e8 d3 e7 ff ff       	call   100267 <cprintf>
  101a94:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a97:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a9e:	0f b7 c0             	movzwl %ax,%eax
  101aa1:	83 ec 08             	sub    $0x8,%esp
  101aa4:	50                   	push   %eax
  101aa5:	68 35 62 10 00       	push   $0x106235
  101aaa:	e8 b8 e7 ff ff       	call   100267 <cprintf>
  101aaf:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ab9:	0f b7 c0             	movzwl %ax,%eax
  101abc:	83 ec 08             	sub    $0x8,%esp
  101abf:	50                   	push   %eax
  101ac0:	68 48 62 10 00       	push   $0x106248
  101ac5:	e8 9d e7 ff ff       	call   100267 <cprintf>
  101aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	8b 40 30             	mov    0x30(%eax),%eax
  101ad3:	83 ec 0c             	sub    $0xc,%esp
  101ad6:	50                   	push   %eax
  101ad7:	e8 16 ff ff ff       	call   1019f2 <trapname>
  101adc:	83 c4 10             	add    $0x10,%esp
  101adf:	89 c2                	mov    %eax,%edx
  101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae4:	8b 40 30             	mov    0x30(%eax),%eax
  101ae7:	83 ec 04             	sub    $0x4,%esp
  101aea:	52                   	push   %edx
  101aeb:	50                   	push   %eax
  101aec:	68 5b 62 10 00       	push   $0x10625b
  101af1:	e8 71 e7 ff ff       	call   100267 <cprintf>
  101af6:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	8b 40 34             	mov    0x34(%eax),%eax
  101aff:	83 ec 08             	sub    $0x8,%esp
  101b02:	50                   	push   %eax
  101b03:	68 6d 62 10 00       	push   $0x10626d
  101b08:	e8 5a e7 ff ff       	call   100267 <cprintf>
  101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	8b 40 38             	mov    0x38(%eax),%eax
  101b16:	83 ec 08             	sub    $0x8,%esp
  101b19:	50                   	push   %eax
  101b1a:	68 7c 62 10 00       	push   $0x10627c
  101b1f:	e8 43 e7 ff ff       	call   100267 <cprintf>
  101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b27:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2e:	0f b7 c0             	movzwl %ax,%eax
  101b31:	83 ec 08             	sub    $0x8,%esp
  101b34:	50                   	push   %eax
  101b35:	68 8b 62 10 00       	push   $0x10628b
  101b3a:	e8 28 e7 ff ff       	call   100267 <cprintf>
  101b3f:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b42:	8b 45 08             	mov    0x8(%ebp),%eax
  101b45:	8b 40 40             	mov    0x40(%eax),%eax
  101b48:	83 ec 08             	sub    $0x8,%esp
  101b4b:	50                   	push   %eax
  101b4c:	68 9e 62 10 00       	push   $0x10629e
  101b51:	e8 11 e7 ff ff       	call   100267 <cprintf>
  101b56:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b67:	eb 3f                	jmp    101ba8 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b69:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6c:	8b 50 40             	mov    0x40(%eax),%edx
  101b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b72:	21 d0                	and    %edx,%eax
  101b74:	85 c0                	test   %eax,%eax
  101b76:	74 29                	je     101ba1 <print_trapframe+0x168>
  101b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b7b:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b82:	85 c0                	test   %eax,%eax
  101b84:	74 1b                	je     101ba1 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b89:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b90:	83 ec 08             	sub    $0x8,%esp
  101b93:	50                   	push   %eax
  101b94:	68 ad 62 10 00       	push   $0x1062ad
  101b99:	e8 c9 e6 ff ff       	call   100267 <cprintf>
  101b9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ba5:	d1 65 f0             	shll   -0x10(%ebp)
  101ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bab:	83 f8 17             	cmp    $0x17,%eax
  101bae:	76 b9                	jbe    101b69 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb3:	8b 40 40             	mov    0x40(%eax),%eax
  101bb6:	25 00 30 00 00       	and    $0x3000,%eax
  101bbb:	c1 e8 0c             	shr    $0xc,%eax
  101bbe:	83 ec 08             	sub    $0x8,%esp
  101bc1:	50                   	push   %eax
  101bc2:	68 b1 62 10 00       	push   $0x1062b1
  101bc7:	e8 9b e6 ff ff       	call   100267 <cprintf>
  101bcc:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bcf:	83 ec 0c             	sub    $0xc,%esp
  101bd2:	ff 75 08             	pushl  0x8(%ebp)
  101bd5:	e8 49 fe ff ff       	call   101a23 <trap_in_kernel>
  101bda:	83 c4 10             	add    $0x10,%esp
  101bdd:	85 c0                	test   %eax,%eax
  101bdf:	75 32                	jne    101c13 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 44             	mov    0x44(%eax),%eax
  101be7:	83 ec 08             	sub    $0x8,%esp
  101bea:	50                   	push   %eax
  101beb:	68 ba 62 10 00       	push   $0x1062ba
  101bf0:	e8 72 e6 ff ff       	call   100267 <cprintf>
  101bf5:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bff:	0f b7 c0             	movzwl %ax,%eax
  101c02:	83 ec 08             	sub    $0x8,%esp
  101c05:	50                   	push   %eax
  101c06:	68 c9 62 10 00       	push   $0x1062c9
  101c0b:	e8 57 e6 ff ff       	call   100267 <cprintf>
  101c10:	83 c4 10             	add    $0x10,%esp
    }
}
  101c13:	90                   	nop
  101c14:	c9                   	leave  
  101c15:	c3                   	ret    

00101c16 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c16:	55                   	push   %ebp
  101c17:	89 e5                	mov    %esp,%ebp
  101c19:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	8b 00                	mov    (%eax),%eax
  101c21:	83 ec 08             	sub    $0x8,%esp
  101c24:	50                   	push   %eax
  101c25:	68 dc 62 10 00       	push   $0x1062dc
  101c2a:	e8 38 e6 ff ff       	call   100267 <cprintf>
  101c2f:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 04             	mov    0x4(%eax),%eax
  101c38:	83 ec 08             	sub    $0x8,%esp
  101c3b:	50                   	push   %eax
  101c3c:	68 eb 62 10 00       	push   $0x1062eb
  101c41:	e8 21 e6 ff ff       	call   100267 <cprintf>
  101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	8b 40 08             	mov    0x8(%eax),%eax
  101c4f:	83 ec 08             	sub    $0x8,%esp
  101c52:	50                   	push   %eax
  101c53:	68 fa 62 10 00       	push   $0x1062fa
  101c58:	e8 0a e6 ff ff       	call   100267 <cprintf>
  101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 40 0c             	mov    0xc(%eax),%eax
  101c66:	83 ec 08             	sub    $0x8,%esp
  101c69:	50                   	push   %eax
  101c6a:	68 09 63 10 00       	push   $0x106309
  101c6f:	e8 f3 e5 ff ff       	call   100267 <cprintf>
  101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 10             	mov    0x10(%eax),%eax
  101c7d:	83 ec 08             	sub    $0x8,%esp
  101c80:	50                   	push   %eax
  101c81:	68 18 63 10 00       	push   $0x106318
  101c86:	e8 dc e5 ff ff       	call   100267 <cprintf>
  101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	8b 40 14             	mov    0x14(%eax),%eax
  101c94:	83 ec 08             	sub    $0x8,%esp
  101c97:	50                   	push   %eax
  101c98:	68 27 63 10 00       	push   $0x106327
  101c9d:	e8 c5 e5 ff ff       	call   100267 <cprintf>
  101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 40 18             	mov    0x18(%eax),%eax
  101cab:	83 ec 08             	sub    $0x8,%esp
  101cae:	50                   	push   %eax
  101caf:	68 36 63 10 00       	push   $0x106336
  101cb4:	e8 ae e5 ff ff       	call   100267 <cprintf>
  101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbf:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cc2:	83 ec 08             	sub    $0x8,%esp
  101cc5:	50                   	push   %eax
  101cc6:	68 45 63 10 00       	push   $0x106345
  101ccb:	e8 97 e5 ff ff       	call   100267 <cprintf>
  101cd0:	83 c4 10             	add    $0x10,%esp
}
  101cd3:	90                   	nop
  101cd4:	c9                   	leave  
  101cd5:	c3                   	ret    

00101cd6 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cd6:	55                   	push   %ebp
  101cd7:	89 e5                	mov    %esp,%ebp
  101cd9:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdf:	8b 40 30             	mov    0x30(%eax),%eax
  101ce2:	83 f8 2f             	cmp    $0x2f,%eax
  101ce5:	77 1e                	ja     101d05 <trap_dispatch+0x2f>
  101ce7:	83 f8 2e             	cmp    $0x2e,%eax
  101cea:	0f 83 b4 00 00 00    	jae    101da4 <trap_dispatch+0xce>
  101cf0:	83 f8 21             	cmp    $0x21,%eax
  101cf3:	74 3e                	je     101d33 <trap_dispatch+0x5d>
  101cf5:	83 f8 24             	cmp    $0x24,%eax
  101cf8:	74 15                	je     101d0f <trap_dispatch+0x39>
  101cfa:	83 f8 20             	cmp    $0x20,%eax
  101cfd:	0f 84 a4 00 00 00    	je     101da7 <trap_dispatch+0xd1>
  101d03:	eb 69                	jmp    101d6e <trap_dispatch+0x98>
  101d05:	83 e8 78             	sub    $0x78,%eax
  101d08:	83 f8 01             	cmp    $0x1,%eax
  101d0b:	77 61                	ja     101d6e <trap_dispatch+0x98>
  101d0d:	eb 48                	jmp    101d57 <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d0f:	e8 0f f9 ff ff       	call   101623 <cons_getc>
  101d14:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d17:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d1b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1f:	83 ec 04             	sub    $0x4,%esp
  101d22:	52                   	push   %edx
  101d23:	50                   	push   %eax
  101d24:	68 54 63 10 00       	push   $0x106354
  101d29:	e8 39 e5 ff ff       	call   100267 <cprintf>
  101d2e:	83 c4 10             	add    $0x10,%esp
        break;
  101d31:	eb 75                	jmp    101da8 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d33:	e8 eb f8 ff ff       	call   101623 <cons_getc>
  101d38:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d3b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d3f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d43:	83 ec 04             	sub    $0x4,%esp
  101d46:	52                   	push   %edx
  101d47:	50                   	push   %eax
  101d48:	68 66 63 10 00       	push   $0x106366
  101d4d:	e8 15 e5 ff ff       	call   100267 <cprintf>
  101d52:	83 c4 10             	add    $0x10,%esp
        break;
  101d55:	eb 51                	jmp    101da8 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d57:	83 ec 04             	sub    $0x4,%esp
  101d5a:	68 75 63 10 00       	push   $0x106375
  101d5f:	68 ac 00 00 00       	push   $0xac
  101d64:	68 85 63 10 00       	push   $0x106385
  101d69:	e8 5f e6 ff ff       	call   1003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d75:	0f b7 c0             	movzwl %ax,%eax
  101d78:	83 e0 03             	and    $0x3,%eax
  101d7b:	85 c0                	test   %eax,%eax
  101d7d:	75 29                	jne    101da8 <trap_dispatch+0xd2>
            print_trapframe(tf);
  101d7f:	83 ec 0c             	sub    $0xc,%esp
  101d82:	ff 75 08             	pushl  0x8(%ebp)
  101d85:	e8 af fc ff ff       	call   101a39 <print_trapframe>
  101d8a:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101d8d:	83 ec 04             	sub    $0x4,%esp
  101d90:	68 96 63 10 00       	push   $0x106396
  101d95:	68 b6 00 00 00       	push   $0xb6
  101d9a:	68 85 63 10 00       	push   $0x106385
  101d9f:	e8 29 e6 ff ff       	call   1003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101da4:	90                   	nop
  101da5:	eb 01                	jmp    101da8 <trap_dispatch+0xd2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101da7:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101da8:	90                   	nop
  101da9:	c9                   	leave  
  101daa:	c3                   	ret    

00101dab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101dab:	55                   	push   %ebp
  101dac:	89 e5                	mov    %esp,%ebp
  101dae:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101db1:	83 ec 0c             	sub    $0xc,%esp
  101db4:	ff 75 08             	pushl  0x8(%ebp)
  101db7:	e8 1a ff ff ff       	call   101cd6 <trap_dispatch>
  101dbc:	83 c4 10             	add    $0x10,%esp
}
  101dbf:	90                   	nop
  101dc0:	c9                   	leave  
  101dc1:	c3                   	ret    

00101dc2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dc2:	6a 00                	push   $0x0
  pushl $0
  101dc4:	6a 00                	push   $0x0
  jmp __alltraps
  101dc6:	e9 67 0a 00 00       	jmp    102832 <__alltraps>

00101dcb <vector1>:
.globl vector1
vector1:
  pushl $0
  101dcb:	6a 00                	push   $0x0
  pushl $1
  101dcd:	6a 01                	push   $0x1
  jmp __alltraps
  101dcf:	e9 5e 0a 00 00       	jmp    102832 <__alltraps>

00101dd4 <vector2>:
.globl vector2
vector2:
  pushl $0
  101dd4:	6a 00                	push   $0x0
  pushl $2
  101dd6:	6a 02                	push   $0x2
  jmp __alltraps
  101dd8:	e9 55 0a 00 00       	jmp    102832 <__alltraps>

00101ddd <vector3>:
.globl vector3
vector3:
  pushl $0
  101ddd:	6a 00                	push   $0x0
  pushl $3
  101ddf:	6a 03                	push   $0x3
  jmp __alltraps
  101de1:	e9 4c 0a 00 00       	jmp    102832 <__alltraps>

00101de6 <vector4>:
.globl vector4
vector4:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $4
  101de8:	6a 04                	push   $0x4
  jmp __alltraps
  101dea:	e9 43 0a 00 00       	jmp    102832 <__alltraps>

00101def <vector5>:
.globl vector5
vector5:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $5
  101df1:	6a 05                	push   $0x5
  jmp __alltraps
  101df3:	e9 3a 0a 00 00       	jmp    102832 <__alltraps>

00101df8 <vector6>:
.globl vector6
vector6:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $6
  101dfa:	6a 06                	push   $0x6
  jmp __alltraps
  101dfc:	e9 31 0a 00 00       	jmp    102832 <__alltraps>

00101e01 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $7
  101e03:	6a 07                	push   $0x7
  jmp __alltraps
  101e05:	e9 28 0a 00 00       	jmp    102832 <__alltraps>

00101e0a <vector8>:
.globl vector8
vector8:
  pushl $8
  101e0a:	6a 08                	push   $0x8
  jmp __alltraps
  101e0c:	e9 21 0a 00 00       	jmp    102832 <__alltraps>

00101e11 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e11:	6a 09                	push   $0x9
  jmp __alltraps
  101e13:	e9 1a 0a 00 00       	jmp    102832 <__alltraps>

00101e18 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e18:	6a 0a                	push   $0xa
  jmp __alltraps
  101e1a:	e9 13 0a 00 00       	jmp    102832 <__alltraps>

00101e1f <vector11>:
.globl vector11
vector11:
  pushl $11
  101e1f:	6a 0b                	push   $0xb
  jmp __alltraps
  101e21:	e9 0c 0a 00 00       	jmp    102832 <__alltraps>

00101e26 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e26:	6a 0c                	push   $0xc
  jmp __alltraps
  101e28:	e9 05 0a 00 00       	jmp    102832 <__alltraps>

00101e2d <vector13>:
.globl vector13
vector13:
  pushl $13
  101e2d:	6a 0d                	push   $0xd
  jmp __alltraps
  101e2f:	e9 fe 09 00 00       	jmp    102832 <__alltraps>

00101e34 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e34:	6a 0e                	push   $0xe
  jmp __alltraps
  101e36:	e9 f7 09 00 00       	jmp    102832 <__alltraps>

00101e3b <vector15>:
.globl vector15
vector15:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $15
  101e3d:	6a 0f                	push   $0xf
  jmp __alltraps
  101e3f:	e9 ee 09 00 00       	jmp    102832 <__alltraps>

00101e44 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $16
  101e46:	6a 10                	push   $0x10
  jmp __alltraps
  101e48:	e9 e5 09 00 00       	jmp    102832 <__alltraps>

00101e4d <vector17>:
.globl vector17
vector17:
  pushl $17
  101e4d:	6a 11                	push   $0x11
  jmp __alltraps
  101e4f:	e9 de 09 00 00       	jmp    102832 <__alltraps>

00101e54 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $18
  101e56:	6a 12                	push   $0x12
  jmp __alltraps
  101e58:	e9 d5 09 00 00       	jmp    102832 <__alltraps>

00101e5d <vector19>:
.globl vector19
vector19:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $19
  101e5f:	6a 13                	push   $0x13
  jmp __alltraps
  101e61:	e9 cc 09 00 00       	jmp    102832 <__alltraps>

00101e66 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $20
  101e68:	6a 14                	push   $0x14
  jmp __alltraps
  101e6a:	e9 c3 09 00 00       	jmp    102832 <__alltraps>

00101e6f <vector21>:
.globl vector21
vector21:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $21
  101e71:	6a 15                	push   $0x15
  jmp __alltraps
  101e73:	e9 ba 09 00 00       	jmp    102832 <__alltraps>

00101e78 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $22
  101e7a:	6a 16                	push   $0x16
  jmp __alltraps
  101e7c:	e9 b1 09 00 00       	jmp    102832 <__alltraps>

00101e81 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $23
  101e83:	6a 17                	push   $0x17
  jmp __alltraps
  101e85:	e9 a8 09 00 00       	jmp    102832 <__alltraps>

00101e8a <vector24>:
.globl vector24
vector24:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $24
  101e8c:	6a 18                	push   $0x18
  jmp __alltraps
  101e8e:	e9 9f 09 00 00       	jmp    102832 <__alltraps>

00101e93 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $25
  101e95:	6a 19                	push   $0x19
  jmp __alltraps
  101e97:	e9 96 09 00 00       	jmp    102832 <__alltraps>

00101e9c <vector26>:
.globl vector26
vector26:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $26
  101e9e:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ea0:	e9 8d 09 00 00       	jmp    102832 <__alltraps>

00101ea5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $27
  101ea7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ea9:	e9 84 09 00 00       	jmp    102832 <__alltraps>

00101eae <vector28>:
.globl vector28
vector28:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $28
  101eb0:	6a 1c                	push   $0x1c
  jmp __alltraps
  101eb2:	e9 7b 09 00 00       	jmp    102832 <__alltraps>

00101eb7 <vector29>:
.globl vector29
vector29:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $29
  101eb9:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ebb:	e9 72 09 00 00       	jmp    102832 <__alltraps>

00101ec0 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $30
  101ec2:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ec4:	e9 69 09 00 00       	jmp    102832 <__alltraps>

00101ec9 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $31
  101ecb:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ecd:	e9 60 09 00 00       	jmp    102832 <__alltraps>

00101ed2 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $32
  101ed4:	6a 20                	push   $0x20
  jmp __alltraps
  101ed6:	e9 57 09 00 00       	jmp    102832 <__alltraps>

00101edb <vector33>:
.globl vector33
vector33:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $33
  101edd:	6a 21                	push   $0x21
  jmp __alltraps
  101edf:	e9 4e 09 00 00       	jmp    102832 <__alltraps>

00101ee4 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $34
  101ee6:	6a 22                	push   $0x22
  jmp __alltraps
  101ee8:	e9 45 09 00 00       	jmp    102832 <__alltraps>

00101eed <vector35>:
.globl vector35
vector35:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $35
  101eef:	6a 23                	push   $0x23
  jmp __alltraps
  101ef1:	e9 3c 09 00 00       	jmp    102832 <__alltraps>

00101ef6 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $36
  101ef8:	6a 24                	push   $0x24
  jmp __alltraps
  101efa:	e9 33 09 00 00       	jmp    102832 <__alltraps>

00101eff <vector37>:
.globl vector37
vector37:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $37
  101f01:	6a 25                	push   $0x25
  jmp __alltraps
  101f03:	e9 2a 09 00 00       	jmp    102832 <__alltraps>

00101f08 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $38
  101f0a:	6a 26                	push   $0x26
  jmp __alltraps
  101f0c:	e9 21 09 00 00       	jmp    102832 <__alltraps>

00101f11 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $39
  101f13:	6a 27                	push   $0x27
  jmp __alltraps
  101f15:	e9 18 09 00 00       	jmp    102832 <__alltraps>

00101f1a <vector40>:
.globl vector40
vector40:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $40
  101f1c:	6a 28                	push   $0x28
  jmp __alltraps
  101f1e:	e9 0f 09 00 00       	jmp    102832 <__alltraps>

00101f23 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $41
  101f25:	6a 29                	push   $0x29
  jmp __alltraps
  101f27:	e9 06 09 00 00       	jmp    102832 <__alltraps>

00101f2c <vector42>:
.globl vector42
vector42:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $42
  101f2e:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f30:	e9 fd 08 00 00       	jmp    102832 <__alltraps>

00101f35 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $43
  101f37:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f39:	e9 f4 08 00 00       	jmp    102832 <__alltraps>

00101f3e <vector44>:
.globl vector44
vector44:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $44
  101f40:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f42:	e9 eb 08 00 00       	jmp    102832 <__alltraps>

00101f47 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $45
  101f49:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f4b:	e9 e2 08 00 00       	jmp    102832 <__alltraps>

00101f50 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $46
  101f52:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f54:	e9 d9 08 00 00       	jmp    102832 <__alltraps>

00101f59 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $47
  101f5b:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f5d:	e9 d0 08 00 00       	jmp    102832 <__alltraps>

00101f62 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $48
  101f64:	6a 30                	push   $0x30
  jmp __alltraps
  101f66:	e9 c7 08 00 00       	jmp    102832 <__alltraps>

00101f6b <vector49>:
.globl vector49
vector49:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $49
  101f6d:	6a 31                	push   $0x31
  jmp __alltraps
  101f6f:	e9 be 08 00 00       	jmp    102832 <__alltraps>

00101f74 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $50
  101f76:	6a 32                	push   $0x32
  jmp __alltraps
  101f78:	e9 b5 08 00 00       	jmp    102832 <__alltraps>

00101f7d <vector51>:
.globl vector51
vector51:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $51
  101f7f:	6a 33                	push   $0x33
  jmp __alltraps
  101f81:	e9 ac 08 00 00       	jmp    102832 <__alltraps>

00101f86 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $52
  101f88:	6a 34                	push   $0x34
  jmp __alltraps
  101f8a:	e9 a3 08 00 00       	jmp    102832 <__alltraps>

00101f8f <vector53>:
.globl vector53
vector53:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $53
  101f91:	6a 35                	push   $0x35
  jmp __alltraps
  101f93:	e9 9a 08 00 00       	jmp    102832 <__alltraps>

00101f98 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $54
  101f9a:	6a 36                	push   $0x36
  jmp __alltraps
  101f9c:	e9 91 08 00 00       	jmp    102832 <__alltraps>

00101fa1 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $55
  101fa3:	6a 37                	push   $0x37
  jmp __alltraps
  101fa5:	e9 88 08 00 00       	jmp    102832 <__alltraps>

00101faa <vector56>:
.globl vector56
vector56:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $56
  101fac:	6a 38                	push   $0x38
  jmp __alltraps
  101fae:	e9 7f 08 00 00       	jmp    102832 <__alltraps>

00101fb3 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $57
  101fb5:	6a 39                	push   $0x39
  jmp __alltraps
  101fb7:	e9 76 08 00 00       	jmp    102832 <__alltraps>

00101fbc <vector58>:
.globl vector58
vector58:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $58
  101fbe:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fc0:	e9 6d 08 00 00       	jmp    102832 <__alltraps>

00101fc5 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $59
  101fc7:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fc9:	e9 64 08 00 00       	jmp    102832 <__alltraps>

00101fce <vector60>:
.globl vector60
vector60:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $60
  101fd0:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fd2:	e9 5b 08 00 00       	jmp    102832 <__alltraps>

00101fd7 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $61
  101fd9:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fdb:	e9 52 08 00 00       	jmp    102832 <__alltraps>

00101fe0 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $62
  101fe2:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fe4:	e9 49 08 00 00       	jmp    102832 <__alltraps>

00101fe9 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $63
  101feb:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fed:	e9 40 08 00 00       	jmp    102832 <__alltraps>

00101ff2 <vector64>:
.globl vector64
vector64:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $64
  101ff4:	6a 40                	push   $0x40
  jmp __alltraps
  101ff6:	e9 37 08 00 00       	jmp    102832 <__alltraps>

00101ffb <vector65>:
.globl vector65
vector65:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $65
  101ffd:	6a 41                	push   $0x41
  jmp __alltraps
  101fff:	e9 2e 08 00 00       	jmp    102832 <__alltraps>

00102004 <vector66>:
.globl vector66
vector66:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $66
  102006:	6a 42                	push   $0x42
  jmp __alltraps
  102008:	e9 25 08 00 00       	jmp    102832 <__alltraps>

0010200d <vector67>:
.globl vector67
vector67:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $67
  10200f:	6a 43                	push   $0x43
  jmp __alltraps
  102011:	e9 1c 08 00 00       	jmp    102832 <__alltraps>

00102016 <vector68>:
.globl vector68
vector68:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $68
  102018:	6a 44                	push   $0x44
  jmp __alltraps
  10201a:	e9 13 08 00 00       	jmp    102832 <__alltraps>

0010201f <vector69>:
.globl vector69
vector69:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $69
  102021:	6a 45                	push   $0x45
  jmp __alltraps
  102023:	e9 0a 08 00 00       	jmp    102832 <__alltraps>

00102028 <vector70>:
.globl vector70
vector70:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $70
  10202a:	6a 46                	push   $0x46
  jmp __alltraps
  10202c:	e9 01 08 00 00       	jmp    102832 <__alltraps>

00102031 <vector71>:
.globl vector71
vector71:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $71
  102033:	6a 47                	push   $0x47
  jmp __alltraps
  102035:	e9 f8 07 00 00       	jmp    102832 <__alltraps>

0010203a <vector72>:
.globl vector72
vector72:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $72
  10203c:	6a 48                	push   $0x48
  jmp __alltraps
  10203e:	e9 ef 07 00 00       	jmp    102832 <__alltraps>

00102043 <vector73>:
.globl vector73
vector73:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $73
  102045:	6a 49                	push   $0x49
  jmp __alltraps
  102047:	e9 e6 07 00 00       	jmp    102832 <__alltraps>

0010204c <vector74>:
.globl vector74
vector74:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $74
  10204e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102050:	e9 dd 07 00 00       	jmp    102832 <__alltraps>

00102055 <vector75>:
.globl vector75
vector75:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $75
  102057:	6a 4b                	push   $0x4b
  jmp __alltraps
  102059:	e9 d4 07 00 00       	jmp    102832 <__alltraps>

0010205e <vector76>:
.globl vector76
vector76:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $76
  102060:	6a 4c                	push   $0x4c
  jmp __alltraps
  102062:	e9 cb 07 00 00       	jmp    102832 <__alltraps>

00102067 <vector77>:
.globl vector77
vector77:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $77
  102069:	6a 4d                	push   $0x4d
  jmp __alltraps
  10206b:	e9 c2 07 00 00       	jmp    102832 <__alltraps>

00102070 <vector78>:
.globl vector78
vector78:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $78
  102072:	6a 4e                	push   $0x4e
  jmp __alltraps
  102074:	e9 b9 07 00 00       	jmp    102832 <__alltraps>

00102079 <vector79>:
.globl vector79
vector79:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $79
  10207b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10207d:	e9 b0 07 00 00       	jmp    102832 <__alltraps>

00102082 <vector80>:
.globl vector80
vector80:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $80
  102084:	6a 50                	push   $0x50
  jmp __alltraps
  102086:	e9 a7 07 00 00       	jmp    102832 <__alltraps>

0010208b <vector81>:
.globl vector81
vector81:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $81
  10208d:	6a 51                	push   $0x51
  jmp __alltraps
  10208f:	e9 9e 07 00 00       	jmp    102832 <__alltraps>

00102094 <vector82>:
.globl vector82
vector82:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $82
  102096:	6a 52                	push   $0x52
  jmp __alltraps
  102098:	e9 95 07 00 00       	jmp    102832 <__alltraps>

0010209d <vector83>:
.globl vector83
vector83:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $83
  10209f:	6a 53                	push   $0x53
  jmp __alltraps
  1020a1:	e9 8c 07 00 00       	jmp    102832 <__alltraps>

001020a6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $84
  1020a8:	6a 54                	push   $0x54
  jmp __alltraps
  1020aa:	e9 83 07 00 00       	jmp    102832 <__alltraps>

001020af <vector85>:
.globl vector85
vector85:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $85
  1020b1:	6a 55                	push   $0x55
  jmp __alltraps
  1020b3:	e9 7a 07 00 00       	jmp    102832 <__alltraps>

001020b8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $86
  1020ba:	6a 56                	push   $0x56
  jmp __alltraps
  1020bc:	e9 71 07 00 00       	jmp    102832 <__alltraps>

001020c1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $87
  1020c3:	6a 57                	push   $0x57
  jmp __alltraps
  1020c5:	e9 68 07 00 00       	jmp    102832 <__alltraps>

001020ca <vector88>:
.globl vector88
vector88:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $88
  1020cc:	6a 58                	push   $0x58
  jmp __alltraps
  1020ce:	e9 5f 07 00 00       	jmp    102832 <__alltraps>

001020d3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $89
  1020d5:	6a 59                	push   $0x59
  jmp __alltraps
  1020d7:	e9 56 07 00 00       	jmp    102832 <__alltraps>

001020dc <vector90>:
.globl vector90
vector90:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $90
  1020de:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020e0:	e9 4d 07 00 00       	jmp    102832 <__alltraps>

001020e5 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $91
  1020e7:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020e9:	e9 44 07 00 00       	jmp    102832 <__alltraps>

001020ee <vector92>:
.globl vector92
vector92:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $92
  1020f0:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020f2:	e9 3b 07 00 00       	jmp    102832 <__alltraps>

001020f7 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $93
  1020f9:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020fb:	e9 32 07 00 00       	jmp    102832 <__alltraps>

00102100 <vector94>:
.globl vector94
vector94:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $94
  102102:	6a 5e                	push   $0x5e
  jmp __alltraps
  102104:	e9 29 07 00 00       	jmp    102832 <__alltraps>

00102109 <vector95>:
.globl vector95
vector95:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $95
  10210b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10210d:	e9 20 07 00 00       	jmp    102832 <__alltraps>

00102112 <vector96>:
.globl vector96
vector96:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $96
  102114:	6a 60                	push   $0x60
  jmp __alltraps
  102116:	e9 17 07 00 00       	jmp    102832 <__alltraps>

0010211b <vector97>:
.globl vector97
vector97:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $97
  10211d:	6a 61                	push   $0x61
  jmp __alltraps
  10211f:	e9 0e 07 00 00       	jmp    102832 <__alltraps>

00102124 <vector98>:
.globl vector98
vector98:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $98
  102126:	6a 62                	push   $0x62
  jmp __alltraps
  102128:	e9 05 07 00 00       	jmp    102832 <__alltraps>

0010212d <vector99>:
.globl vector99
vector99:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $99
  10212f:	6a 63                	push   $0x63
  jmp __alltraps
  102131:	e9 fc 06 00 00       	jmp    102832 <__alltraps>

00102136 <vector100>:
.globl vector100
vector100:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $100
  102138:	6a 64                	push   $0x64
  jmp __alltraps
  10213a:	e9 f3 06 00 00       	jmp    102832 <__alltraps>

0010213f <vector101>:
.globl vector101
vector101:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $101
  102141:	6a 65                	push   $0x65
  jmp __alltraps
  102143:	e9 ea 06 00 00       	jmp    102832 <__alltraps>

00102148 <vector102>:
.globl vector102
vector102:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $102
  10214a:	6a 66                	push   $0x66
  jmp __alltraps
  10214c:	e9 e1 06 00 00       	jmp    102832 <__alltraps>

00102151 <vector103>:
.globl vector103
vector103:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $103
  102153:	6a 67                	push   $0x67
  jmp __alltraps
  102155:	e9 d8 06 00 00       	jmp    102832 <__alltraps>

0010215a <vector104>:
.globl vector104
vector104:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $104
  10215c:	6a 68                	push   $0x68
  jmp __alltraps
  10215e:	e9 cf 06 00 00       	jmp    102832 <__alltraps>

00102163 <vector105>:
.globl vector105
vector105:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $105
  102165:	6a 69                	push   $0x69
  jmp __alltraps
  102167:	e9 c6 06 00 00       	jmp    102832 <__alltraps>

0010216c <vector106>:
.globl vector106
vector106:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $106
  10216e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102170:	e9 bd 06 00 00       	jmp    102832 <__alltraps>

00102175 <vector107>:
.globl vector107
vector107:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $107
  102177:	6a 6b                	push   $0x6b
  jmp __alltraps
  102179:	e9 b4 06 00 00       	jmp    102832 <__alltraps>

0010217e <vector108>:
.globl vector108
vector108:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $108
  102180:	6a 6c                	push   $0x6c
  jmp __alltraps
  102182:	e9 ab 06 00 00       	jmp    102832 <__alltraps>

00102187 <vector109>:
.globl vector109
vector109:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $109
  102189:	6a 6d                	push   $0x6d
  jmp __alltraps
  10218b:	e9 a2 06 00 00       	jmp    102832 <__alltraps>

00102190 <vector110>:
.globl vector110
vector110:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $110
  102192:	6a 6e                	push   $0x6e
  jmp __alltraps
  102194:	e9 99 06 00 00       	jmp    102832 <__alltraps>

00102199 <vector111>:
.globl vector111
vector111:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $111
  10219b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10219d:	e9 90 06 00 00       	jmp    102832 <__alltraps>

001021a2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $112
  1021a4:	6a 70                	push   $0x70
  jmp __alltraps
  1021a6:	e9 87 06 00 00       	jmp    102832 <__alltraps>

001021ab <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $113
  1021ad:	6a 71                	push   $0x71
  jmp __alltraps
  1021af:	e9 7e 06 00 00       	jmp    102832 <__alltraps>

001021b4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $114
  1021b6:	6a 72                	push   $0x72
  jmp __alltraps
  1021b8:	e9 75 06 00 00       	jmp    102832 <__alltraps>

001021bd <vector115>:
.globl vector115
vector115:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $115
  1021bf:	6a 73                	push   $0x73
  jmp __alltraps
  1021c1:	e9 6c 06 00 00       	jmp    102832 <__alltraps>

001021c6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $116
  1021c8:	6a 74                	push   $0x74
  jmp __alltraps
  1021ca:	e9 63 06 00 00       	jmp    102832 <__alltraps>

001021cf <vector117>:
.globl vector117
vector117:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $117
  1021d1:	6a 75                	push   $0x75
  jmp __alltraps
  1021d3:	e9 5a 06 00 00       	jmp    102832 <__alltraps>

001021d8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $118
  1021da:	6a 76                	push   $0x76
  jmp __alltraps
  1021dc:	e9 51 06 00 00       	jmp    102832 <__alltraps>

001021e1 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $119
  1021e3:	6a 77                	push   $0x77
  jmp __alltraps
  1021e5:	e9 48 06 00 00       	jmp    102832 <__alltraps>

001021ea <vector120>:
.globl vector120
vector120:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $120
  1021ec:	6a 78                	push   $0x78
  jmp __alltraps
  1021ee:	e9 3f 06 00 00       	jmp    102832 <__alltraps>

001021f3 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $121
  1021f5:	6a 79                	push   $0x79
  jmp __alltraps
  1021f7:	e9 36 06 00 00       	jmp    102832 <__alltraps>

001021fc <vector122>:
.globl vector122
vector122:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $122
  1021fe:	6a 7a                	push   $0x7a
  jmp __alltraps
  102200:	e9 2d 06 00 00       	jmp    102832 <__alltraps>

00102205 <vector123>:
.globl vector123
vector123:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $123
  102207:	6a 7b                	push   $0x7b
  jmp __alltraps
  102209:	e9 24 06 00 00       	jmp    102832 <__alltraps>

0010220e <vector124>:
.globl vector124
vector124:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $124
  102210:	6a 7c                	push   $0x7c
  jmp __alltraps
  102212:	e9 1b 06 00 00       	jmp    102832 <__alltraps>

00102217 <vector125>:
.globl vector125
vector125:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $125
  102219:	6a 7d                	push   $0x7d
  jmp __alltraps
  10221b:	e9 12 06 00 00       	jmp    102832 <__alltraps>

00102220 <vector126>:
.globl vector126
vector126:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $126
  102222:	6a 7e                	push   $0x7e
  jmp __alltraps
  102224:	e9 09 06 00 00       	jmp    102832 <__alltraps>

00102229 <vector127>:
.globl vector127
vector127:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $127
  10222b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10222d:	e9 00 06 00 00       	jmp    102832 <__alltraps>

00102232 <vector128>:
.globl vector128
vector128:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $128
  102234:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102239:	e9 f4 05 00 00       	jmp    102832 <__alltraps>

0010223e <vector129>:
.globl vector129
vector129:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $129
  102240:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102245:	e9 e8 05 00 00       	jmp    102832 <__alltraps>

0010224a <vector130>:
.globl vector130
vector130:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $130
  10224c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102251:	e9 dc 05 00 00       	jmp    102832 <__alltraps>

00102256 <vector131>:
.globl vector131
vector131:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $131
  102258:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10225d:	e9 d0 05 00 00       	jmp    102832 <__alltraps>

00102262 <vector132>:
.globl vector132
vector132:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $132
  102264:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102269:	e9 c4 05 00 00       	jmp    102832 <__alltraps>

0010226e <vector133>:
.globl vector133
vector133:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $133
  102270:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102275:	e9 b8 05 00 00       	jmp    102832 <__alltraps>

0010227a <vector134>:
.globl vector134
vector134:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $134
  10227c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102281:	e9 ac 05 00 00       	jmp    102832 <__alltraps>

00102286 <vector135>:
.globl vector135
vector135:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $135
  102288:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10228d:	e9 a0 05 00 00       	jmp    102832 <__alltraps>

00102292 <vector136>:
.globl vector136
vector136:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $136
  102294:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102299:	e9 94 05 00 00       	jmp    102832 <__alltraps>

0010229e <vector137>:
.globl vector137
vector137:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $137
  1022a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022a5:	e9 88 05 00 00       	jmp    102832 <__alltraps>

001022aa <vector138>:
.globl vector138
vector138:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $138
  1022ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022b1:	e9 7c 05 00 00       	jmp    102832 <__alltraps>

001022b6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $139
  1022b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022bd:	e9 70 05 00 00       	jmp    102832 <__alltraps>

001022c2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $140
  1022c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022c9:	e9 64 05 00 00       	jmp    102832 <__alltraps>

001022ce <vector141>:
.globl vector141
vector141:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $141
  1022d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022d5:	e9 58 05 00 00       	jmp    102832 <__alltraps>

001022da <vector142>:
.globl vector142
vector142:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $142
  1022dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022e1:	e9 4c 05 00 00       	jmp    102832 <__alltraps>

001022e6 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $143
  1022e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022ed:	e9 40 05 00 00       	jmp    102832 <__alltraps>

001022f2 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $144
  1022f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022f9:	e9 34 05 00 00       	jmp    102832 <__alltraps>

001022fe <vector145>:
.globl vector145
vector145:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $145
  102300:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102305:	e9 28 05 00 00       	jmp    102832 <__alltraps>

0010230a <vector146>:
.globl vector146
vector146:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $146
  10230c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102311:	e9 1c 05 00 00       	jmp    102832 <__alltraps>

00102316 <vector147>:
.globl vector147
vector147:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $147
  102318:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10231d:	e9 10 05 00 00       	jmp    102832 <__alltraps>

00102322 <vector148>:
.globl vector148
vector148:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $148
  102324:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102329:	e9 04 05 00 00       	jmp    102832 <__alltraps>

0010232e <vector149>:
.globl vector149
vector149:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $149
  102330:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102335:	e9 f8 04 00 00       	jmp    102832 <__alltraps>

0010233a <vector150>:
.globl vector150
vector150:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $150
  10233c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102341:	e9 ec 04 00 00       	jmp    102832 <__alltraps>

00102346 <vector151>:
.globl vector151
vector151:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $151
  102348:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10234d:	e9 e0 04 00 00       	jmp    102832 <__alltraps>

00102352 <vector152>:
.globl vector152
vector152:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $152
  102354:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102359:	e9 d4 04 00 00       	jmp    102832 <__alltraps>

0010235e <vector153>:
.globl vector153
vector153:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $153
  102360:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102365:	e9 c8 04 00 00       	jmp    102832 <__alltraps>

0010236a <vector154>:
.globl vector154
vector154:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $154
  10236c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102371:	e9 bc 04 00 00       	jmp    102832 <__alltraps>

00102376 <vector155>:
.globl vector155
vector155:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $155
  102378:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10237d:	e9 b0 04 00 00       	jmp    102832 <__alltraps>

00102382 <vector156>:
.globl vector156
vector156:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $156
  102384:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102389:	e9 a4 04 00 00       	jmp    102832 <__alltraps>

0010238e <vector157>:
.globl vector157
vector157:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $157
  102390:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102395:	e9 98 04 00 00       	jmp    102832 <__alltraps>

0010239a <vector158>:
.globl vector158
vector158:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $158
  10239c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023a1:	e9 8c 04 00 00       	jmp    102832 <__alltraps>

001023a6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $159
  1023a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023ad:	e9 80 04 00 00       	jmp    102832 <__alltraps>

001023b2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $160
  1023b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023b9:	e9 74 04 00 00       	jmp    102832 <__alltraps>

001023be <vector161>:
.globl vector161
vector161:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $161
  1023c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023c5:	e9 68 04 00 00       	jmp    102832 <__alltraps>

001023ca <vector162>:
.globl vector162
vector162:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $162
  1023cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023d1:	e9 5c 04 00 00       	jmp    102832 <__alltraps>

001023d6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $163
  1023d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023dd:	e9 50 04 00 00       	jmp    102832 <__alltraps>

001023e2 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $164
  1023e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023e9:	e9 44 04 00 00       	jmp    102832 <__alltraps>

001023ee <vector165>:
.globl vector165
vector165:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $165
  1023f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023f5:	e9 38 04 00 00       	jmp    102832 <__alltraps>

001023fa <vector166>:
.globl vector166
vector166:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $166
  1023fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102401:	e9 2c 04 00 00       	jmp    102832 <__alltraps>

00102406 <vector167>:
.globl vector167
vector167:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $167
  102408:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10240d:	e9 20 04 00 00       	jmp    102832 <__alltraps>

00102412 <vector168>:
.globl vector168
vector168:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $168
  102414:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102419:	e9 14 04 00 00       	jmp    102832 <__alltraps>

0010241e <vector169>:
.globl vector169
vector169:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $169
  102420:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102425:	e9 08 04 00 00       	jmp    102832 <__alltraps>

0010242a <vector170>:
.globl vector170
vector170:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $170
  10242c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102431:	e9 fc 03 00 00       	jmp    102832 <__alltraps>

00102436 <vector171>:
.globl vector171
vector171:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $171
  102438:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10243d:	e9 f0 03 00 00       	jmp    102832 <__alltraps>

00102442 <vector172>:
.globl vector172
vector172:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $172
  102444:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102449:	e9 e4 03 00 00       	jmp    102832 <__alltraps>

0010244e <vector173>:
.globl vector173
vector173:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $173
  102450:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102455:	e9 d8 03 00 00       	jmp    102832 <__alltraps>

0010245a <vector174>:
.globl vector174
vector174:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $174
  10245c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102461:	e9 cc 03 00 00       	jmp    102832 <__alltraps>

00102466 <vector175>:
.globl vector175
vector175:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $175
  102468:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10246d:	e9 c0 03 00 00       	jmp    102832 <__alltraps>

00102472 <vector176>:
.globl vector176
vector176:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $176
  102474:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102479:	e9 b4 03 00 00       	jmp    102832 <__alltraps>

0010247e <vector177>:
.globl vector177
vector177:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $177
  102480:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102485:	e9 a8 03 00 00       	jmp    102832 <__alltraps>

0010248a <vector178>:
.globl vector178
vector178:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $178
  10248c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102491:	e9 9c 03 00 00       	jmp    102832 <__alltraps>

00102496 <vector179>:
.globl vector179
vector179:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $179
  102498:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10249d:	e9 90 03 00 00       	jmp    102832 <__alltraps>

001024a2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $180
  1024a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024a9:	e9 84 03 00 00       	jmp    102832 <__alltraps>

001024ae <vector181>:
.globl vector181
vector181:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $181
  1024b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024b5:	e9 78 03 00 00       	jmp    102832 <__alltraps>

001024ba <vector182>:
.globl vector182
vector182:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $182
  1024bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024c1:	e9 6c 03 00 00       	jmp    102832 <__alltraps>

001024c6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $183
  1024c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024cd:	e9 60 03 00 00       	jmp    102832 <__alltraps>

001024d2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $184
  1024d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024d9:	e9 54 03 00 00       	jmp    102832 <__alltraps>

001024de <vector185>:
.globl vector185
vector185:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $185
  1024e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024e5:	e9 48 03 00 00       	jmp    102832 <__alltraps>

001024ea <vector186>:
.globl vector186
vector186:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $186
  1024ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024f1:	e9 3c 03 00 00       	jmp    102832 <__alltraps>

001024f6 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $187
  1024f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024fd:	e9 30 03 00 00       	jmp    102832 <__alltraps>

00102502 <vector188>:
.globl vector188
vector188:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $188
  102504:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102509:	e9 24 03 00 00       	jmp    102832 <__alltraps>

0010250e <vector189>:
.globl vector189
vector189:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $189
  102510:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102515:	e9 18 03 00 00       	jmp    102832 <__alltraps>

0010251a <vector190>:
.globl vector190
vector190:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $190
  10251c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102521:	e9 0c 03 00 00       	jmp    102832 <__alltraps>

00102526 <vector191>:
.globl vector191
vector191:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $191
  102528:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10252d:	e9 00 03 00 00       	jmp    102832 <__alltraps>

00102532 <vector192>:
.globl vector192
vector192:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $192
  102534:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102539:	e9 f4 02 00 00       	jmp    102832 <__alltraps>

0010253e <vector193>:
.globl vector193
vector193:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $193
  102540:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102545:	e9 e8 02 00 00       	jmp    102832 <__alltraps>

0010254a <vector194>:
.globl vector194
vector194:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $194
  10254c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102551:	e9 dc 02 00 00       	jmp    102832 <__alltraps>

00102556 <vector195>:
.globl vector195
vector195:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $195
  102558:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10255d:	e9 d0 02 00 00       	jmp    102832 <__alltraps>

00102562 <vector196>:
.globl vector196
vector196:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $196
  102564:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102569:	e9 c4 02 00 00       	jmp    102832 <__alltraps>

0010256e <vector197>:
.globl vector197
vector197:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $197
  102570:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102575:	e9 b8 02 00 00       	jmp    102832 <__alltraps>

0010257a <vector198>:
.globl vector198
vector198:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $198
  10257c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102581:	e9 ac 02 00 00       	jmp    102832 <__alltraps>

00102586 <vector199>:
.globl vector199
vector199:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $199
  102588:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10258d:	e9 a0 02 00 00       	jmp    102832 <__alltraps>

00102592 <vector200>:
.globl vector200
vector200:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $200
  102594:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102599:	e9 94 02 00 00       	jmp    102832 <__alltraps>

0010259e <vector201>:
.globl vector201
vector201:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $201
  1025a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025a5:	e9 88 02 00 00       	jmp    102832 <__alltraps>

001025aa <vector202>:
.globl vector202
vector202:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $202
  1025ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025b1:	e9 7c 02 00 00       	jmp    102832 <__alltraps>

001025b6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $203
  1025b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025bd:	e9 70 02 00 00       	jmp    102832 <__alltraps>

001025c2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $204
  1025c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025c9:	e9 64 02 00 00       	jmp    102832 <__alltraps>

001025ce <vector205>:
.globl vector205
vector205:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $205
  1025d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025d5:	e9 58 02 00 00       	jmp    102832 <__alltraps>

001025da <vector206>:
.globl vector206
vector206:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $206
  1025dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025e1:	e9 4c 02 00 00       	jmp    102832 <__alltraps>

001025e6 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $207
  1025e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025ed:	e9 40 02 00 00       	jmp    102832 <__alltraps>

001025f2 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $208
  1025f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025f9:	e9 34 02 00 00       	jmp    102832 <__alltraps>

001025fe <vector209>:
.globl vector209
vector209:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $209
  102600:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102605:	e9 28 02 00 00       	jmp    102832 <__alltraps>

0010260a <vector210>:
.globl vector210
vector210:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $210
  10260c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102611:	e9 1c 02 00 00       	jmp    102832 <__alltraps>

00102616 <vector211>:
.globl vector211
vector211:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $211
  102618:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10261d:	e9 10 02 00 00       	jmp    102832 <__alltraps>

00102622 <vector212>:
.globl vector212
vector212:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $212
  102624:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102629:	e9 04 02 00 00       	jmp    102832 <__alltraps>

0010262e <vector213>:
.globl vector213
vector213:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $213
  102630:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102635:	e9 f8 01 00 00       	jmp    102832 <__alltraps>

0010263a <vector214>:
.globl vector214
vector214:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $214
  10263c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102641:	e9 ec 01 00 00       	jmp    102832 <__alltraps>

00102646 <vector215>:
.globl vector215
vector215:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $215
  102648:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10264d:	e9 e0 01 00 00       	jmp    102832 <__alltraps>

00102652 <vector216>:
.globl vector216
vector216:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $216
  102654:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102659:	e9 d4 01 00 00       	jmp    102832 <__alltraps>

0010265e <vector217>:
.globl vector217
vector217:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $217
  102660:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102665:	e9 c8 01 00 00       	jmp    102832 <__alltraps>

0010266a <vector218>:
.globl vector218
vector218:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $218
  10266c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102671:	e9 bc 01 00 00       	jmp    102832 <__alltraps>

00102676 <vector219>:
.globl vector219
vector219:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $219
  102678:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10267d:	e9 b0 01 00 00       	jmp    102832 <__alltraps>

00102682 <vector220>:
.globl vector220
vector220:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $220
  102684:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102689:	e9 a4 01 00 00       	jmp    102832 <__alltraps>

0010268e <vector221>:
.globl vector221
vector221:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $221
  102690:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102695:	e9 98 01 00 00       	jmp    102832 <__alltraps>

0010269a <vector222>:
.globl vector222
vector222:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $222
  10269c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026a1:	e9 8c 01 00 00       	jmp    102832 <__alltraps>

001026a6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $223
  1026a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026ad:	e9 80 01 00 00       	jmp    102832 <__alltraps>

001026b2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $224
  1026b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026b9:	e9 74 01 00 00       	jmp    102832 <__alltraps>

001026be <vector225>:
.globl vector225
vector225:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $225
  1026c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026c5:	e9 68 01 00 00       	jmp    102832 <__alltraps>

001026ca <vector226>:
.globl vector226
vector226:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $226
  1026cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026d1:	e9 5c 01 00 00       	jmp    102832 <__alltraps>

001026d6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $227
  1026d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026dd:	e9 50 01 00 00       	jmp    102832 <__alltraps>

001026e2 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $228
  1026e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026e9:	e9 44 01 00 00       	jmp    102832 <__alltraps>

001026ee <vector229>:
.globl vector229
vector229:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $229
  1026f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026f5:	e9 38 01 00 00       	jmp    102832 <__alltraps>

001026fa <vector230>:
.globl vector230
vector230:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $230
  1026fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102701:	e9 2c 01 00 00       	jmp    102832 <__alltraps>

00102706 <vector231>:
.globl vector231
vector231:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $231
  102708:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10270d:	e9 20 01 00 00       	jmp    102832 <__alltraps>

00102712 <vector232>:
.globl vector232
vector232:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $232
  102714:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102719:	e9 14 01 00 00       	jmp    102832 <__alltraps>

0010271e <vector233>:
.globl vector233
vector233:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $233
  102720:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102725:	e9 08 01 00 00       	jmp    102832 <__alltraps>

0010272a <vector234>:
.globl vector234
vector234:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $234
  10272c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102731:	e9 fc 00 00 00       	jmp    102832 <__alltraps>

00102736 <vector235>:
.globl vector235
vector235:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $235
  102738:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10273d:	e9 f0 00 00 00       	jmp    102832 <__alltraps>

00102742 <vector236>:
.globl vector236
vector236:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $236
  102744:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102749:	e9 e4 00 00 00       	jmp    102832 <__alltraps>

0010274e <vector237>:
.globl vector237
vector237:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $237
  102750:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102755:	e9 d8 00 00 00       	jmp    102832 <__alltraps>

0010275a <vector238>:
.globl vector238
vector238:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $238
  10275c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102761:	e9 cc 00 00 00       	jmp    102832 <__alltraps>

00102766 <vector239>:
.globl vector239
vector239:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $239
  102768:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10276d:	e9 c0 00 00 00       	jmp    102832 <__alltraps>

00102772 <vector240>:
.globl vector240
vector240:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $240
  102774:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102779:	e9 b4 00 00 00       	jmp    102832 <__alltraps>

0010277e <vector241>:
.globl vector241
vector241:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $241
  102780:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102785:	e9 a8 00 00 00       	jmp    102832 <__alltraps>

0010278a <vector242>:
.globl vector242
vector242:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $242
  10278c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102791:	e9 9c 00 00 00       	jmp    102832 <__alltraps>

00102796 <vector243>:
.globl vector243
vector243:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $243
  102798:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10279d:	e9 90 00 00 00       	jmp    102832 <__alltraps>

001027a2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $244
  1027a4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027a9:	e9 84 00 00 00       	jmp    102832 <__alltraps>

001027ae <vector245>:
.globl vector245
vector245:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $245
  1027b0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027b5:	e9 78 00 00 00       	jmp    102832 <__alltraps>

001027ba <vector246>:
.globl vector246
vector246:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $246
  1027bc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027c1:	e9 6c 00 00 00       	jmp    102832 <__alltraps>

001027c6 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $247
  1027c8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027cd:	e9 60 00 00 00       	jmp    102832 <__alltraps>

001027d2 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $248
  1027d4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027d9:	e9 54 00 00 00       	jmp    102832 <__alltraps>

001027de <vector249>:
.globl vector249
vector249:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $249
  1027e0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027e5:	e9 48 00 00 00       	jmp    102832 <__alltraps>

001027ea <vector250>:
.globl vector250
vector250:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $250
  1027ec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027f1:	e9 3c 00 00 00       	jmp    102832 <__alltraps>

001027f6 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $251
  1027f8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027fd:	e9 30 00 00 00       	jmp    102832 <__alltraps>

00102802 <vector252>:
.globl vector252
vector252:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $252
  102804:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102809:	e9 24 00 00 00       	jmp    102832 <__alltraps>

0010280e <vector253>:
.globl vector253
vector253:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $253
  102810:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102815:	e9 18 00 00 00       	jmp    102832 <__alltraps>

0010281a <vector254>:
.globl vector254
vector254:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $254
  10281c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102821:	e9 0c 00 00 00       	jmp    102832 <__alltraps>

00102826 <vector255>:
.globl vector255
vector255:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $255
  102828:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10282d:	e9 00 00 00 00       	jmp    102832 <__alltraps>

00102832 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102832:	1e                   	push   %ds
    pushl %es
  102833:	06                   	push   %es
    pushl %fs
  102834:	0f a0                	push   %fs
    pushl %gs
  102836:	0f a8                	push   %gs
    pushal
  102838:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102839:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10283e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102840:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102842:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102843:	e8 63 f5 ff ff       	call   101dab <trap>

    # pop the pushed stack pointer
    popl %esp
  102848:	5c                   	pop    %esp

00102849 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102849:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10284a:	0f a9                	pop    %gs
    popl %fs
  10284c:	0f a1                	pop    %fs
    popl %es
  10284e:	07                   	pop    %es
    popl %ds
  10284f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102850:	83 c4 08             	add    $0x8,%esp
    iret
  102853:	cf                   	iret   

00102854 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102854:	55                   	push   %ebp
  102855:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102857:	8b 45 08             	mov    0x8(%ebp),%eax
  10285a:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102860:	29 d0                	sub    %edx,%eax
  102862:	c1 f8 02             	sar    $0x2,%eax
  102865:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10286b:	5d                   	pop    %ebp
  10286c:	c3                   	ret    

0010286d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10286d:	55                   	push   %ebp
  10286e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  102870:	ff 75 08             	pushl  0x8(%ebp)
  102873:	e8 dc ff ff ff       	call   102854 <page2ppn>
  102878:	83 c4 04             	add    $0x4,%esp
  10287b:	c1 e0 0c             	shl    $0xc,%eax
}
  10287e:	c9                   	leave  
  10287f:	c3                   	ret    

00102880 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102880:	55                   	push   %ebp
  102881:	89 e5                	mov    %esp,%ebp
  102883:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  102886:	8b 45 08             	mov    0x8(%ebp),%eax
  102889:	c1 e8 0c             	shr    $0xc,%eax
  10288c:	89 c2                	mov    %eax,%edx
  10288e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102893:	39 c2                	cmp    %eax,%edx
  102895:	72 14                	jb     1028ab <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  102897:	83 ec 04             	sub    $0x4,%esp
  10289a:	68 50 65 10 00       	push   $0x106550
  10289f:	6a 5a                	push   $0x5a
  1028a1:	68 6f 65 10 00       	push   $0x10656f
  1028a6:	e8 22 db ff ff       	call   1003cd <__panic>
    }
    return &pages[PPN(pa)];
  1028ab:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  1028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b4:	c1 e8 0c             	shr    $0xc,%eax
  1028b7:	89 c2                	mov    %eax,%edx
  1028b9:	89 d0                	mov    %edx,%eax
  1028bb:	c1 e0 02             	shl    $0x2,%eax
  1028be:	01 d0                	add    %edx,%eax
  1028c0:	c1 e0 02             	shl    $0x2,%eax
  1028c3:	01 c8                	add    %ecx,%eax
}
  1028c5:	c9                   	leave  
  1028c6:	c3                   	ret    

001028c7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1028c7:	55                   	push   %ebp
  1028c8:	89 e5                	mov    %esp,%ebp
  1028ca:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  1028cd:	ff 75 08             	pushl  0x8(%ebp)
  1028d0:	e8 98 ff ff ff       	call   10286d <page2pa>
  1028d5:	83 c4 04             	add    $0x4,%esp
  1028d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028de:	c1 e8 0c             	shr    $0xc,%eax
  1028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1028e4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1028e9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1028ec:	72 14                	jb     102902 <page2kva+0x3b>
  1028ee:	ff 75 f4             	pushl  -0xc(%ebp)
  1028f1:	68 80 65 10 00       	push   $0x106580
  1028f6:	6a 61                	push   $0x61
  1028f8:	68 6f 65 10 00       	push   $0x10656f
  1028fd:	e8 cb da ff ff       	call   1003cd <__panic>
  102902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102905:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  10290a:	c9                   	leave  
  10290b:	c3                   	ret    

0010290c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  10290c:	55                   	push   %ebp
  10290d:	89 e5                	mov    %esp,%ebp
  10290f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102912:	8b 45 08             	mov    0x8(%ebp),%eax
  102915:	83 e0 01             	and    $0x1,%eax
  102918:	85 c0                	test   %eax,%eax
  10291a:	75 14                	jne    102930 <pte2page+0x24>
        panic("pte2page called with invalid pte");
  10291c:	83 ec 04             	sub    $0x4,%esp
  10291f:	68 a4 65 10 00       	push   $0x1065a4
  102924:	6a 6c                	push   $0x6c
  102926:	68 6f 65 10 00       	push   $0x10656f
  10292b:	e8 9d da ff ff       	call   1003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102930:	8b 45 08             	mov    0x8(%ebp),%eax
  102933:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102938:	83 ec 0c             	sub    $0xc,%esp
  10293b:	50                   	push   %eax
  10293c:	e8 3f ff ff ff       	call   102880 <pa2page>
  102941:	83 c4 10             	add    $0x10,%esp
}
  102944:	c9                   	leave  
  102945:	c3                   	ret    

00102946 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102946:	55                   	push   %ebp
  102947:	89 e5                	mov    %esp,%ebp
  102949:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  10294c:	8b 45 08             	mov    0x8(%ebp),%eax
  10294f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102954:	83 ec 0c             	sub    $0xc,%esp
  102957:	50                   	push   %eax
  102958:	e8 23 ff ff ff       	call   102880 <pa2page>
  10295d:	83 c4 10             	add    $0x10,%esp
}
  102960:	c9                   	leave  
  102961:	c3                   	ret    

00102962 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102962:	55                   	push   %ebp
  102963:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102965:	8b 45 08             	mov    0x8(%ebp),%eax
  102968:	8b 00                	mov    (%eax),%eax
}
  10296a:	5d                   	pop    %ebp
  10296b:	c3                   	ret    

0010296c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10296c:	55                   	push   %ebp
  10296d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10296f:	8b 45 08             	mov    0x8(%ebp),%eax
  102972:	8b 55 0c             	mov    0xc(%ebp),%edx
  102975:	89 10                	mov    %edx,(%eax)
}
  102977:	90                   	nop
  102978:	5d                   	pop    %ebp
  102979:	c3                   	ret    

0010297a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  10297a:	55                   	push   %ebp
  10297b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  10297d:	8b 45 08             	mov    0x8(%ebp),%eax
  102980:	8b 00                	mov    (%eax),%eax
  102982:	8d 50 01             	lea    0x1(%eax),%edx
  102985:	8b 45 08             	mov    0x8(%ebp),%eax
  102988:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10298a:	8b 45 08             	mov    0x8(%ebp),%eax
  10298d:	8b 00                	mov    (%eax),%eax
}
  10298f:	5d                   	pop    %ebp
  102990:	c3                   	ret    

00102991 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102991:	55                   	push   %ebp
  102992:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102994:	8b 45 08             	mov    0x8(%ebp),%eax
  102997:	8b 00                	mov    (%eax),%eax
  102999:	8d 50 ff             	lea    -0x1(%eax),%edx
  10299c:	8b 45 08             	mov    0x8(%ebp),%eax
  10299f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a4:	8b 00                	mov    (%eax),%eax
}
  1029a6:	5d                   	pop    %ebp
  1029a7:	c3                   	ret    

001029a8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  1029a8:	55                   	push   %ebp
  1029a9:	89 e5                	mov    %esp,%ebp
  1029ab:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1029ae:	9c                   	pushf  
  1029af:	58                   	pop    %eax
  1029b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1029b6:	25 00 02 00 00       	and    $0x200,%eax
  1029bb:	85 c0                	test   %eax,%eax
  1029bd:	74 0c                	je     1029cb <__intr_save+0x23>
        intr_disable();
  1029bf:	e8 9b ee ff ff       	call   10185f <intr_disable>
        return 1;
  1029c4:	b8 01 00 00 00       	mov    $0x1,%eax
  1029c9:	eb 05                	jmp    1029d0 <__intr_save+0x28>
    }
    return 0;
  1029cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1029d0:	c9                   	leave  
  1029d1:	c3                   	ret    

001029d2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  1029d2:	55                   	push   %ebp
  1029d3:	89 e5                	mov    %esp,%ebp
  1029d5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  1029d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029dc:	74 05                	je     1029e3 <__intr_restore+0x11>
        intr_enable();
  1029de:	e8 75 ee ff ff       	call   101858 <intr_enable>
    }
}
  1029e3:	90                   	nop
  1029e4:	c9                   	leave  
  1029e5:	c3                   	ret    

001029e6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029e6:	55                   	push   %ebp
  1029e7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ec:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029ef:	b8 23 00 00 00       	mov    $0x23,%eax
  1029f4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029f6:	b8 23 00 00 00       	mov    $0x23,%eax
  1029fb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029fd:	b8 10 00 00 00       	mov    $0x10,%eax
  102a02:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a04:	b8 10 00 00 00       	mov    $0x10,%eax
  102a09:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a0b:	b8 10 00 00 00       	mov    $0x10,%eax
  102a10:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a12:	ea 19 2a 10 00 08 00 	ljmp   $0x8,$0x102a19
}
  102a19:	90                   	nop
  102a1a:	5d                   	pop    %ebp
  102a1b:	c3                   	ret    

00102a1c <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a1c:	55                   	push   %ebp
  102a1d:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a22:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102a27:	90                   	nop
  102a28:	5d                   	pop    %ebp
  102a29:	c3                   	ret    

00102a2a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a2a:	55                   	push   %ebp
  102a2b:	89 e5                	mov    %esp,%ebp
  102a2d:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a30:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a35:	50                   	push   %eax
  102a36:	e8 e1 ff ff ff       	call   102a1c <load_esp0>
  102a3b:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102a3e:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102a45:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102a47:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102a4e:	68 00 
  102a50:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102a55:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102a5b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102a60:	c1 e8 10             	shr    $0x10,%eax
  102a63:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102a68:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a6f:	83 e0 f0             	and    $0xfffffff0,%eax
  102a72:	83 c8 09             	or     $0x9,%eax
  102a75:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a7a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a81:	83 e0 ef             	and    $0xffffffef,%eax
  102a84:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a89:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a90:	83 e0 9f             	and    $0xffffff9f,%eax
  102a93:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a98:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a9f:	83 c8 80             	or     $0xffffff80,%eax
  102aa2:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102aa7:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aae:	83 e0 f0             	and    $0xfffffff0,%eax
  102ab1:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ab6:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102abd:	83 e0 ef             	and    $0xffffffef,%eax
  102ac0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ac5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102acc:	83 e0 df             	and    $0xffffffdf,%eax
  102acf:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ad4:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102adb:	83 c8 40             	or     $0x40,%eax
  102ade:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ae3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aea:	83 e0 7f             	and    $0x7f,%eax
  102aed:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102af2:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102af7:	c1 e8 18             	shr    $0x18,%eax
  102afa:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102aff:	68 30 7a 11 00       	push   $0x117a30
  102b04:	e8 dd fe ff ff       	call   1029e6 <lgdt>
  102b09:	83 c4 04             	add    $0x4,%esp
  102b0c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102b12:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b16:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b19:	90                   	nop
  102b1a:	c9                   	leave  
  102b1b:	c3                   	ret    

00102b1c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b1c:	55                   	push   %ebp
  102b1d:	89 e5                	mov    %esp,%ebp
  102b1f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102b22:	c7 05 50 89 11 00 dc 	movl   $0x106fdc,0x118950
  102b29:	6f 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b2c:	a1 50 89 11 00       	mov    0x118950,%eax
  102b31:	8b 00                	mov    (%eax),%eax
  102b33:	83 ec 08             	sub    $0x8,%esp
  102b36:	50                   	push   %eax
  102b37:	68 d0 65 10 00       	push   $0x1065d0
  102b3c:	e8 26 d7 ff ff       	call   100267 <cprintf>
  102b41:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102b44:	a1 50 89 11 00       	mov    0x118950,%eax
  102b49:	8b 40 04             	mov    0x4(%eax),%eax
  102b4c:	ff d0                	call   *%eax
}
  102b4e:	90                   	nop
  102b4f:	c9                   	leave  
  102b50:	c3                   	ret    

00102b51 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102b51:	55                   	push   %ebp
  102b52:	89 e5                	mov    %esp,%ebp
  102b54:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102b57:	a1 50 89 11 00       	mov    0x118950,%eax
  102b5c:	8b 40 08             	mov    0x8(%eax),%eax
  102b5f:	83 ec 08             	sub    $0x8,%esp
  102b62:	ff 75 0c             	pushl  0xc(%ebp)
  102b65:	ff 75 08             	pushl  0x8(%ebp)
  102b68:	ff d0                	call   *%eax
  102b6a:	83 c4 10             	add    $0x10,%esp
}
  102b6d:	90                   	nop
  102b6e:	c9                   	leave  
  102b6f:	c3                   	ret    

00102b70 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102b70:	55                   	push   %ebp
  102b71:	89 e5                	mov    %esp,%ebp
  102b73:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102b76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102b7d:	e8 26 fe ff ff       	call   1029a8 <__intr_save>
  102b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102b85:	a1 50 89 11 00       	mov    0x118950,%eax
  102b8a:	8b 40 0c             	mov    0xc(%eax),%eax
  102b8d:	83 ec 0c             	sub    $0xc,%esp
  102b90:	ff 75 08             	pushl  0x8(%ebp)
  102b93:	ff d0                	call   *%eax
  102b95:	83 c4 10             	add    $0x10,%esp
  102b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102b9b:	83 ec 0c             	sub    $0xc,%esp
  102b9e:	ff 75 f0             	pushl  -0x10(%ebp)
  102ba1:	e8 2c fe ff ff       	call   1029d2 <__intr_restore>
  102ba6:	83 c4 10             	add    $0x10,%esp
    return page;
  102ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bac:	c9                   	leave  
  102bad:	c3                   	ret    

00102bae <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102bae:	55                   	push   %ebp
  102baf:	89 e5                	mov    %esp,%ebp
  102bb1:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102bb4:	e8 ef fd ff ff       	call   1029a8 <__intr_save>
  102bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102bbc:	a1 50 89 11 00       	mov    0x118950,%eax
  102bc1:	8b 40 10             	mov    0x10(%eax),%eax
  102bc4:	83 ec 08             	sub    $0x8,%esp
  102bc7:	ff 75 0c             	pushl  0xc(%ebp)
  102bca:	ff 75 08             	pushl  0x8(%ebp)
  102bcd:	ff d0                	call   *%eax
  102bcf:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102bd2:	83 ec 0c             	sub    $0xc,%esp
  102bd5:	ff 75 f4             	pushl  -0xc(%ebp)
  102bd8:	e8 f5 fd ff ff       	call   1029d2 <__intr_restore>
  102bdd:	83 c4 10             	add    $0x10,%esp
}
  102be0:	90                   	nop
  102be1:	c9                   	leave  
  102be2:	c3                   	ret    

00102be3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102be3:	55                   	push   %ebp
  102be4:	89 e5                	mov    %esp,%ebp
  102be6:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102be9:	e8 ba fd ff ff       	call   1029a8 <__intr_save>
  102bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102bf1:	a1 50 89 11 00       	mov    0x118950,%eax
  102bf6:	8b 40 14             	mov    0x14(%eax),%eax
  102bf9:	ff d0                	call   *%eax
  102bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102bfe:	83 ec 0c             	sub    $0xc,%esp
  102c01:	ff 75 f4             	pushl  -0xc(%ebp)
  102c04:	e8 c9 fd ff ff       	call   1029d2 <__intr_restore>
  102c09:	83 c4 10             	add    $0x10,%esp
    return ret;
  102c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c0f:	c9                   	leave  
  102c10:	c3                   	ret    

00102c11 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102c11:	55                   	push   %ebp
  102c12:	89 e5                	mov    %esp,%ebp
  102c14:	57                   	push   %edi
  102c15:	56                   	push   %esi
  102c16:	53                   	push   %ebx
  102c17:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102c1a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c21:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c2f:	83 ec 0c             	sub    $0xc,%esp
  102c32:	68 e7 65 10 00       	push   $0x1065e7
  102c37:	e8 2b d6 ff ff       	call   100267 <cprintf>
  102c3c:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c46:	e9 fc 00 00 00       	jmp    102d47 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c51:	89 d0                	mov    %edx,%eax
  102c53:	c1 e0 02             	shl    $0x2,%eax
  102c56:	01 d0                	add    %edx,%eax
  102c58:	c1 e0 02             	shl    $0x2,%eax
  102c5b:	01 c8                	add    %ecx,%eax
  102c5d:	8b 50 08             	mov    0x8(%eax),%edx
  102c60:	8b 40 04             	mov    0x4(%eax),%eax
  102c63:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102c66:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102c69:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c6f:	89 d0                	mov    %edx,%eax
  102c71:	c1 e0 02             	shl    $0x2,%eax
  102c74:	01 d0                	add    %edx,%eax
  102c76:	c1 e0 02             	shl    $0x2,%eax
  102c79:	01 c8                	add    %ecx,%eax
  102c7b:	8b 48 0c             	mov    0xc(%eax),%ecx
  102c7e:	8b 58 10             	mov    0x10(%eax),%ebx
  102c81:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102c84:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c87:	01 c8                	add    %ecx,%eax
  102c89:	11 da                	adc    %ebx,%edx
  102c8b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102c8e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102c91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c97:	89 d0                	mov    %edx,%eax
  102c99:	c1 e0 02             	shl    $0x2,%eax
  102c9c:	01 d0                	add    %edx,%eax
  102c9e:	c1 e0 02             	shl    $0x2,%eax
  102ca1:	01 c8                	add    %ecx,%eax
  102ca3:	83 c0 14             	add    $0x14,%eax
  102ca6:	8b 00                	mov    (%eax),%eax
  102ca8:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102cab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102cae:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102cb1:	83 c0 ff             	add    $0xffffffff,%eax
  102cb4:	83 d2 ff             	adc    $0xffffffff,%edx
  102cb7:	89 c1                	mov    %eax,%ecx
  102cb9:	89 d3                	mov    %edx,%ebx
  102cbb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102cbe:	89 55 80             	mov    %edx,-0x80(%ebp)
  102cc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cc4:	89 d0                	mov    %edx,%eax
  102cc6:	c1 e0 02             	shl    $0x2,%eax
  102cc9:	01 d0                	add    %edx,%eax
  102ccb:	c1 e0 02             	shl    $0x2,%eax
  102cce:	03 45 80             	add    -0x80(%ebp),%eax
  102cd1:	8b 50 10             	mov    0x10(%eax),%edx
  102cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  102cd7:	ff 75 84             	pushl  -0x7c(%ebp)
  102cda:	53                   	push   %ebx
  102cdb:	51                   	push   %ecx
  102cdc:	ff 75 bc             	pushl  -0x44(%ebp)
  102cdf:	ff 75 b8             	pushl  -0x48(%ebp)
  102ce2:	52                   	push   %edx
  102ce3:	50                   	push   %eax
  102ce4:	68 f4 65 10 00       	push   $0x1065f4
  102ce9:	e8 79 d5 ff ff       	call   100267 <cprintf>
  102cee:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102cf1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cf4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cf7:	89 d0                	mov    %edx,%eax
  102cf9:	c1 e0 02             	shl    $0x2,%eax
  102cfc:	01 d0                	add    %edx,%eax
  102cfe:	c1 e0 02             	shl    $0x2,%eax
  102d01:	01 c8                	add    %ecx,%eax
  102d03:	83 c0 14             	add    $0x14,%eax
  102d06:	8b 00                	mov    (%eax),%eax
  102d08:	83 f8 01             	cmp    $0x1,%eax
  102d0b:	75 36                	jne    102d43 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d13:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d16:	77 2b                	ja     102d43 <page_init+0x132>
  102d18:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d1b:	72 05                	jb     102d22 <page_init+0x111>
  102d1d:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102d20:	73 21                	jae    102d43 <page_init+0x132>
  102d22:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d26:	77 1b                	ja     102d43 <page_init+0x132>
  102d28:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d2c:	72 09                	jb     102d37 <page_init+0x126>
  102d2e:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102d35:	77 0c                	ja     102d43 <page_init+0x132>
                maxpa = end;
  102d37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d3a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d40:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d43:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102d47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d4a:	8b 00                	mov    (%eax),%eax
  102d4c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102d4f:	0f 8f f6 fe ff ff    	jg     102c4b <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102d55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d59:	72 1d                	jb     102d78 <page_init+0x167>
  102d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d5f:	77 09                	ja     102d6a <page_init+0x159>
  102d61:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102d68:	76 0e                	jbe    102d78 <page_init+0x167>
        maxpa = KMEMSIZE;
  102d6a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102d71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d7e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102d82:	c1 ea 0c             	shr    $0xc,%edx
  102d85:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102d8a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102d91:	b8 68 89 11 00       	mov    $0x118968,%eax
  102d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d99:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d9c:	01 d0                	add    %edx,%eax
  102d9e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102da1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102da4:	ba 00 00 00 00       	mov    $0x0,%edx
  102da9:	f7 75 ac             	divl   -0x54(%ebp)
  102dac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102daf:	29 d0                	sub    %edx,%eax
  102db1:	a3 58 89 11 00       	mov    %eax,0x118958
    
    for (i = 0; i < npage; i ++) {
  102db6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102dbd:	eb 2f                	jmp    102dee <page_init+0x1dd>
        SetPageReserved(pages + i);
  102dbf:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dc8:	89 d0                	mov    %edx,%eax
  102dca:	c1 e0 02             	shl    $0x2,%eax
  102dcd:	01 d0                	add    %edx,%eax
  102dcf:	c1 e0 02             	shl    $0x2,%eax
  102dd2:	01 c8                	add    %ecx,%eax
  102dd4:	83 c0 04             	add    $0x4,%eax
  102dd7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102dde:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102de1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102de4:	8b 55 90             	mov    -0x70(%ebp),%edx
  102de7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    
    for (i = 0; i < npage; i ++) {
  102dea:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102df1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102df6:	39 c2                	cmp    %eax,%edx
  102df8:	72 c5                	jb     102dbf <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102dfa:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102e00:	89 d0                	mov    %edx,%eax
  102e02:	c1 e0 02             	shl    $0x2,%eax
  102e05:	01 d0                	add    %edx,%eax
  102e07:	c1 e0 02             	shl    $0x2,%eax
  102e0a:	89 c2                	mov    %eax,%edx
  102e0c:	a1 58 89 11 00       	mov    0x118958,%eax
  102e11:	01 d0                	add    %edx,%eax
  102e13:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102e16:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102e1d:	77 17                	ja     102e36 <page_init+0x225>
  102e1f:	ff 75 a4             	pushl  -0x5c(%ebp)
  102e22:	68 24 66 10 00       	push   $0x106624
  102e27:	68 db 00 00 00       	push   $0xdb
  102e2c:	68 48 66 10 00       	push   $0x106648
  102e31:	e8 97 d5 ff ff       	call   1003cd <__panic>
  102e36:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e39:	05 00 00 00 40       	add    $0x40000000,%eax
  102e3e:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102e41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e48:	e9 69 01 00 00       	jmp    102fb6 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e53:	89 d0                	mov    %edx,%eax
  102e55:	c1 e0 02             	shl    $0x2,%eax
  102e58:	01 d0                	add    %edx,%eax
  102e5a:	c1 e0 02             	shl    $0x2,%eax
  102e5d:	01 c8                	add    %ecx,%eax
  102e5f:	8b 50 08             	mov    0x8(%eax),%edx
  102e62:	8b 40 04             	mov    0x4(%eax),%eax
  102e65:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e68:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e71:	89 d0                	mov    %edx,%eax
  102e73:	c1 e0 02             	shl    $0x2,%eax
  102e76:	01 d0                	add    %edx,%eax
  102e78:	c1 e0 02             	shl    $0x2,%eax
  102e7b:	01 c8                	add    %ecx,%eax
  102e7d:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e80:	8b 58 10             	mov    0x10(%eax),%ebx
  102e83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e89:	01 c8                	add    %ecx,%eax
  102e8b:	11 da                	adc    %ebx,%edx
  102e8d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102e90:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102e93:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e99:	89 d0                	mov    %edx,%eax
  102e9b:	c1 e0 02             	shl    $0x2,%eax
  102e9e:	01 d0                	add    %edx,%eax
  102ea0:	c1 e0 02             	shl    $0x2,%eax
  102ea3:	01 c8                	add    %ecx,%eax
  102ea5:	83 c0 14             	add    $0x14,%eax
  102ea8:	8b 00                	mov    (%eax),%eax
  102eaa:	83 f8 01             	cmp    $0x1,%eax
  102ead:	0f 85 ff 00 00 00    	jne    102fb2 <page_init+0x3a1>
            if (begin < freemem) {
  102eb3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102eb6:	ba 00 00 00 00       	mov    $0x0,%edx
  102ebb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ebe:	72 17                	jb     102ed7 <page_init+0x2c6>
  102ec0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ec3:	77 05                	ja     102eca <page_init+0x2b9>
  102ec5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ec8:	76 0d                	jbe    102ed7 <page_init+0x2c6>
                begin = freemem;
  102eca:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ecd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ed0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102ed7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102edb:	72 1d                	jb     102efa <page_init+0x2e9>
  102edd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102ee1:	77 09                	ja     102eec <page_init+0x2db>
  102ee3:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102eea:	76 0e                	jbe    102efa <page_init+0x2e9>
                end = KMEMSIZE;
  102eec:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102ef3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102efa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102efd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f00:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f03:	0f 87 a9 00 00 00    	ja     102fb2 <page_init+0x3a1>
  102f09:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f0c:	72 09                	jb     102f17 <page_init+0x306>
  102f0e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f11:	0f 83 9b 00 00 00    	jae    102fb2 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  102f17:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102f1e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f21:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f24:	01 d0                	add    %edx,%eax
  102f26:	83 e8 01             	sub    $0x1,%eax
  102f29:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f2c:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f2f:	ba 00 00 00 00       	mov    $0x0,%edx
  102f34:	f7 75 9c             	divl   -0x64(%ebp)
  102f37:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f3a:	29 d0                	sub    %edx,%eax
  102f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  102f41:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102f47:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f4a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f4d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f50:	ba 00 00 00 00       	mov    $0x0,%edx
  102f55:	89 c3                	mov    %eax,%ebx
  102f57:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102f5d:	89 de                	mov    %ebx,%esi
  102f5f:	89 d0                	mov    %edx,%eax
  102f61:	83 e0 00             	and    $0x0,%eax
  102f64:	89 c7                	mov    %eax,%edi
  102f66:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102f69:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102f6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f72:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f75:	77 3b                	ja     102fb2 <page_init+0x3a1>
  102f77:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f7a:	72 05                	jb     102f81 <page_init+0x370>
  102f7c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f7f:	73 31                	jae    102fb2 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102f81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f84:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102f87:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102f8a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102f8d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f91:	c1 ea 0c             	shr    $0xc,%edx
  102f94:	89 c3                	mov    %eax,%ebx
  102f96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f99:	83 ec 0c             	sub    $0xc,%esp
  102f9c:	50                   	push   %eax
  102f9d:	e8 de f8 ff ff       	call   102880 <pa2page>
  102fa2:	83 c4 10             	add    $0x10,%esp
  102fa5:	83 ec 08             	sub    $0x8,%esp
  102fa8:	53                   	push   %ebx
  102fa9:	50                   	push   %eax
  102faa:	e8 a2 fb ff ff       	call   102b51 <init_memmap>
  102faf:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  102fb2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102fb6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fb9:	8b 00                	mov    (%eax),%eax
  102fbb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102fbe:	0f 8f 89 fe ff ff    	jg     102e4d <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  102fc4:	90                   	nop
  102fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  102fc8:	5b                   	pop    %ebx
  102fc9:	5e                   	pop    %esi
  102fca:	5f                   	pop    %edi
  102fcb:	5d                   	pop    %ebp
  102fcc:	c3                   	ret    

00102fcd <enable_paging>:

static void
enable_paging(void) {
  102fcd:	55                   	push   %ebp
  102fce:	89 e5                	mov    %esp,%ebp
  102fd0:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  102fd3:	a1 54 89 11 00       	mov    0x118954,%eax
  102fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  102fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fde:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  102fe1:	0f 20 c0             	mov    %cr0,%eax
  102fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  102fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  102fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  102fed:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  102ff4:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  102ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  102ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103001:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103004:	90                   	nop
  103005:	c9                   	leave  
  103006:	c3                   	ret    

00103007 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103007:	55                   	push   %ebp
  103008:	89 e5                	mov    %esp,%ebp
  10300a:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103010:	33 45 14             	xor    0x14(%ebp),%eax
  103013:	25 ff 0f 00 00       	and    $0xfff,%eax
  103018:	85 c0                	test   %eax,%eax
  10301a:	74 19                	je     103035 <boot_map_segment+0x2e>
  10301c:	68 56 66 10 00       	push   $0x106656
  103021:	68 6d 66 10 00       	push   $0x10666d
  103026:	68 04 01 00 00       	push   $0x104
  10302b:	68 48 66 10 00       	push   $0x106648
  103030:	e8 98 d3 ff ff       	call   1003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103035:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10303c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303f:	25 ff 0f 00 00       	and    $0xfff,%eax
  103044:	89 c2                	mov    %eax,%edx
  103046:	8b 45 10             	mov    0x10(%ebp),%eax
  103049:	01 c2                	add    %eax,%edx
  10304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304e:	01 d0                	add    %edx,%eax
  103050:	83 e8 01             	sub    $0x1,%eax
  103053:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103059:	ba 00 00 00 00       	mov    $0x0,%edx
  10305e:	f7 75 f0             	divl   -0x10(%ebp)
  103061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103064:	29 d0                	sub    %edx,%eax
  103066:	c1 e8 0c             	shr    $0xc,%eax
  103069:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10307a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10307d:	8b 45 14             	mov    0x14(%ebp),%eax
  103080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10308b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10308e:	eb 57                	jmp    1030e7 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103090:	83 ec 04             	sub    $0x4,%esp
  103093:	6a 01                	push   $0x1
  103095:	ff 75 0c             	pushl  0xc(%ebp)
  103098:	ff 75 08             	pushl  0x8(%ebp)
  10309b:	e8 98 01 00 00       	call   103238 <get_pte>
  1030a0:	83 c4 10             	add    $0x10,%esp
  1030a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1030a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1030aa:	75 19                	jne    1030c5 <boot_map_segment+0xbe>
  1030ac:	68 82 66 10 00       	push   $0x106682
  1030b1:	68 6d 66 10 00       	push   $0x10666d
  1030b6:	68 0a 01 00 00       	push   $0x10a
  1030bb:	68 48 66 10 00       	push   $0x106648
  1030c0:	e8 08 d3 ff ff       	call   1003cd <__panic>
        *ptep = pa | PTE_P | perm;
  1030c5:	8b 45 14             	mov    0x14(%ebp),%eax
  1030c8:	0b 45 18             	or     0x18(%ebp),%eax
  1030cb:	83 c8 01             	or     $0x1,%eax
  1030ce:	89 c2                	mov    %eax,%edx
  1030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030d3:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1030d9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1030e0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030eb:	75 a3                	jne    103090 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1030ed:	90                   	nop
  1030ee:	c9                   	leave  
  1030ef:	c3                   	ret    

001030f0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1030f0:	55                   	push   %ebp
  1030f1:	89 e5                	mov    %esp,%ebp
  1030f3:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  1030f6:	83 ec 0c             	sub    $0xc,%esp
  1030f9:	6a 01                	push   $0x1
  1030fb:	e8 70 fa ff ff       	call   102b70 <alloc_pages>
  103100:	83 c4 10             	add    $0x10,%esp
  103103:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10310a:	75 17                	jne    103123 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10310c:	83 ec 04             	sub    $0x4,%esp
  10310f:	68 8f 66 10 00       	push   $0x10668f
  103114:	68 16 01 00 00       	push   $0x116
  103119:	68 48 66 10 00       	push   $0x106648
  10311e:	e8 aa d2 ff ff       	call   1003cd <__panic>
    }
    return page2kva(p);
  103123:	83 ec 0c             	sub    $0xc,%esp
  103126:	ff 75 f4             	pushl  -0xc(%ebp)
  103129:	e8 99 f7 ff ff       	call   1028c7 <page2kva>
  10312e:	83 c4 10             	add    $0x10,%esp
}
  103131:	c9                   	leave  
  103132:	c3                   	ret    

00103133 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103133:	55                   	push   %ebp
  103134:	89 e5                	mov    %esp,%ebp
  103136:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103139:	e8 de f9 ff ff       	call   102b1c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10313e:	e8 ce fa ff ff       	call   102c11 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103143:	e8 48 05 00 00       	call   103690 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  103148:	e8 a3 ff ff ff       	call   1030f0 <boot_alloc_page>
  10314d:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  103152:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103157:	83 ec 04             	sub    $0x4,%esp
  10315a:	68 00 10 00 00       	push   $0x1000
  10315f:	6a 00                	push   $0x0
  103161:	50                   	push   %eax
  103162:	e8 2f 25 00 00       	call   105696 <memset>
  103167:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  10316a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10316f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103172:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103179:	77 17                	ja     103192 <pmm_init+0x5f>
  10317b:	ff 75 f4             	pushl  -0xc(%ebp)
  10317e:	68 24 66 10 00       	push   $0x106624
  103183:	68 30 01 00 00       	push   $0x130
  103188:	68 48 66 10 00       	push   $0x106648
  10318d:	e8 3b d2 ff ff       	call   1003cd <__panic>
  103192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103195:	05 00 00 00 40       	add    $0x40000000,%eax
  10319a:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  10319f:	e8 0f 05 00 00       	call   1036b3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1031a4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031a9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1031af:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031b7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1031be:	77 17                	ja     1031d7 <pmm_init+0xa4>
  1031c0:	ff 75 f0             	pushl  -0x10(%ebp)
  1031c3:	68 24 66 10 00       	push   $0x106624
  1031c8:	68 38 01 00 00       	push   $0x138
  1031cd:	68 48 66 10 00       	push   $0x106648
  1031d2:	e8 f6 d1 ff ff       	call   1003cd <__panic>
  1031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031da:	05 00 00 00 40       	add    $0x40000000,%eax
  1031df:	83 c8 03             	or     $0x3,%eax
  1031e2:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1031e4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031e9:	83 ec 0c             	sub    $0xc,%esp
  1031ec:	6a 02                	push   $0x2
  1031ee:	6a 00                	push   $0x0
  1031f0:	68 00 00 00 38       	push   $0x38000000
  1031f5:	68 00 00 00 c0       	push   $0xc0000000
  1031fa:	50                   	push   %eax
  1031fb:	e8 07 fe ff ff       	call   103007 <boot_map_segment>
  103200:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103203:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103208:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10320e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103214:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103216:	e8 b2 fd ff ff       	call   102fcd <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10321b:	e8 0a f8 ff ff       	call   102a2a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103220:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103225:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10322b:	e8 e9 09 00 00       	call   103c19 <check_boot_pgdir>

    print_pgdir();
  103230:	e8 df 0d 00 00       	call   104014 <print_pgdir>

}
  103235:	90                   	nop
  103236:	c9                   	leave  
  103237:	c3                   	ret    

00103238 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte( pde_t *pgdir, uintptr_t la, bool create ) 
{
  103238:	55                   	push   %ebp
  103239:	89 e5                	mov    %esp,%ebp
  10323b:	83 ec 38             	sub    $0x38,%esp
    //
    
    uintptr_t pdx, ptx, pt_pa;
    struct Page *new_page_table; 
    
    pdx = PDX( la );
  10323e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103241:	c1 e8 16             	shr    $0x16,%eax
  103244:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ptx = PTX( la );
  103247:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324a:	c1 e8 0c             	shr    $0xc,%eax
  10324d:	25 ff 03 00 00       	and    $0x3ff,%eax
  103252:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if( pgdir[ pdx ] & PTE_P )
  103255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10325f:	8b 45 08             	mov    0x8(%ebp),%eax
  103262:	01 d0                	add    %edx,%eax
  103264:	8b 00                	mov    (%eax),%eax
  103266:	83 e0 01             	and    $0x1,%eax
  103269:	85 c0                	test   %eax,%eax
  10326b:	74 5a                	je     1032c7 <get_pte+0x8f>
        return &( ( pte_t * )( KADDR( PDE_ADDR( pgdir[ pdx ] ) ) ) )[ ptx ]; 
  10326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103277:	8b 45 08             	mov    0x8(%ebp),%eax
  10327a:	01 d0                	add    %edx,%eax
  10327c:	8b 00                	mov    (%eax),%eax
  10327e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103283:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103289:	c1 e8 0c             	shr    $0xc,%eax
  10328c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10328f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103294:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103297:	72 17                	jb     1032b0 <get_pte+0x78>
  103299:	ff 75 ec             	pushl  -0x14(%ebp)
  10329c:	68 80 65 10 00       	push   $0x106580
  1032a1:	68 86 01 00 00       	push   $0x186
  1032a6:	68 48 66 10 00       	push   $0x106648
  1032ab:	e8 1d d1 ff ff       	call   1003cd <__panic>
  1032b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032b3:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1032b8:	89 c2                	mov    %eax,%edx
  1032ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032bd:	c1 e0 02             	shl    $0x2,%eax
  1032c0:	01 d0                	add    %edx,%eax
  1032c2:	e9 a2 01 00 00       	jmp    103469 <get_pte+0x231>
    else
    {
        if( 0 == create )
  1032c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032cb:	75 0a                	jne    1032d7 <get_pte+0x9f>
            return NULL;
  1032cd:	b8 00 00 00 00       	mov    $0x0,%eax
  1032d2:	e9 92 01 00 00       	jmp    103469 <get_pte+0x231>
        else
        {
            cprintf( "\n\npages = %08x\n\n",pages );
  1032d7:	a1 58 89 11 00       	mov    0x118958,%eax
  1032dc:	83 ec 08             	sub    $0x8,%esp
  1032df:	50                   	push   %eax
  1032e0:	68 a8 66 10 00       	push   $0x1066a8
  1032e5:	e8 7d cf ff ff       	call   100267 <cprintf>
  1032ea:	83 c4 10             	add    $0x10,%esp
            new_page_table = alloc_page();
  1032ed:	83 ec 0c             	sub    $0xc,%esp
  1032f0:	6a 01                	push   $0x1
  1032f2:	e8 79 f8 ff ff       	call   102b70 <alloc_pages>
  1032f7:	83 c4 10             	add    $0x10,%esp
  1032fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            cprintf("new_page_table - pages = 0x%08x\n", new_page_table - pages );
  1032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103300:	8b 15 58 89 11 00    	mov    0x118958,%edx
  103306:	29 d0                	sub    %edx,%eax
  103308:	c1 f8 02             	sar    $0x2,%eax
  10330b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  103311:	83 ec 08             	sub    $0x8,%esp
  103314:	50                   	push   %eax
  103315:	68 bc 66 10 00       	push   $0x1066bc
  10331a:	e8 48 cf ff ff       	call   100267 <cprintf>
  10331f:	83 c4 10             	add    $0x10,%esp
            cprintf("new_page_table = 0x%08x\n", new_page_table);
  103322:	83 ec 08             	sub    $0x8,%esp
  103325:	ff 75 e4             	pushl  -0x1c(%ebp)
  103328:	68 dd 66 10 00       	push   $0x1066dd
  10332d:	e8 35 cf ff ff       	call   100267 <cprintf>
  103332:	83 c4 10             	add    $0x10,%esp
            set_page_ref( new_page_table, 1 ); 
  103335:	83 ec 08             	sub    $0x8,%esp
  103338:	6a 01                	push   $0x1
  10333a:	ff 75 e4             	pushl  -0x1c(%ebp)
  10333d:	e8 2a f6 ff ff       	call   10296c <set_page_ref>
  103342:	83 c4 10             	add    $0x10,%esp
            pt_pa = page2pa( new_page_table );
  103345:	83 ec 0c             	sub    $0xc,%esp
  103348:	ff 75 e4             	pushl  -0x1c(%ebp)
  10334b:	e8 1d f5 ff ff       	call   10286d <page2pa>
  103350:	83 c4 10             	add    $0x10,%esp
  103353:	89 45 e0             	mov    %eax,-0x20(%ebp)
            cprintf("pt_pa = 0x%08x\n", pt_pa);
  103356:	83 ec 08             	sub    $0x8,%esp
  103359:	ff 75 e0             	pushl  -0x20(%ebp)
  10335c:	68 f6 66 10 00       	push   $0x1066f6
  103361:	e8 01 cf ff ff       	call   100267 <cprintf>
  103366:	83 c4 10             	add    $0x10,%esp
            cprintf("KADDR(pt_pa) = 0x%08x\n", KADDR( pt_pa ));
  103369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10336c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10336f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103372:	c1 e8 0c             	shr    $0xc,%eax
  103375:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103378:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10337d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103380:	72 17                	jb     103399 <get_pte+0x161>
  103382:	ff 75 dc             	pushl  -0x24(%ebp)
  103385:	68 80 65 10 00       	push   $0x106580
  10338a:	68 94 01 00 00       	push   $0x194
  10338f:	68 48 66 10 00       	push   $0x106648
  103394:	e8 34 d0 ff ff       	call   1003cd <__panic>
  103399:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10339c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1033a1:	83 ec 08             	sub    $0x8,%esp
  1033a4:	50                   	push   %eax
  1033a5:	68 06 67 10 00       	push   $0x106706
  1033aa:	e8 b8 ce ff ff       	call   100267 <cprintf>
  1033af:	83 c4 10             	add    $0x10,%esp
            memset( KADDR( pt_pa ), 0, PGSIZE );
  1033b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1033b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1033bb:	c1 e8 0c             	shr    $0xc,%eax
  1033be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033c1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1033c6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1033c9:	72 17                	jb     1033e2 <get_pte+0x1aa>
  1033cb:	ff 75 d4             	pushl  -0x2c(%ebp)
  1033ce:	68 80 65 10 00       	push   $0x106580
  1033d3:	68 95 01 00 00       	push   $0x195
  1033d8:	68 48 66 10 00       	push   $0x106648
  1033dd:	e8 eb cf ff ff       	call   1003cd <__panic>
  1033e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1033e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1033ea:	83 ec 04             	sub    $0x4,%esp
  1033ed:	68 00 10 00 00       	push   $0x1000
  1033f2:	6a 00                	push   $0x0
  1033f4:	50                   	push   %eax
  1033f5:	e8 9c 22 00 00       	call   105696 <memset>
  1033fa:	83 c4 10             	add    $0x10,%esp
            pgdir[ pdx ] = pt_pa | ( PTE_P | PTE_W | PTE_U ); 
  1033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103400:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103407:	8b 45 08             	mov    0x8(%ebp),%eax
  10340a:	01 d0                	add    %edx,%eax
  10340c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10340f:	83 ca 07             	or     $0x7,%edx
  103412:	89 10                	mov    %edx,(%eax)
        }
        return &( ( pte_t * )( KADDR( PDE_ADDR( pgdir[ pdx ] ) ) ) )[ ptx ]; 
  103414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10341e:	8b 45 08             	mov    0x8(%ebp),%eax
  103421:	01 d0                	add    %edx,%eax
  103423:	8b 00                	mov    (%eax),%eax
  103425:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10342a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10342d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103430:	c1 e8 0c             	shr    $0xc,%eax
  103433:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103436:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10343b:	39 45 c8             	cmp    %eax,-0x38(%ebp)
  10343e:	72 17                	jb     103457 <get_pte+0x21f>
  103440:	ff 75 cc             	pushl  -0x34(%ebp)
  103443:	68 80 65 10 00       	push   $0x106580
  103448:	68 98 01 00 00       	push   $0x198
  10344d:	68 48 66 10 00       	push   $0x106648
  103452:	e8 76 cf ff ff       	call   1003cd <__panic>
  103457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10345a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10345f:	89 c2                	mov    %eax,%edx
  103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103464:	c1 e0 02             	shl    $0x2,%eax
  103467:	01 d0                	add    %edx,%eax
    }
}
  103469:	c9                   	leave  
  10346a:	c3                   	ret    

0010346b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10346b:	55                   	push   %ebp
  10346c:	89 e5                	mov    %esp,%ebp
  10346e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103471:	83 ec 04             	sub    $0x4,%esp
  103474:	6a 00                	push   $0x0
  103476:	ff 75 0c             	pushl  0xc(%ebp)
  103479:	ff 75 08             	pushl  0x8(%ebp)
  10347c:	e8 b7 fd ff ff       	call   103238 <get_pte>
  103481:	83 c4 10             	add    $0x10,%esp
  103484:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10348b:	74 08                	je     103495 <get_page+0x2a>
        *ptep_store = ptep;
  10348d:	8b 45 10             	mov    0x10(%ebp),%eax
  103490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103493:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103499:	74 1f                	je     1034ba <get_page+0x4f>
  10349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10349e:	8b 00                	mov    (%eax),%eax
  1034a0:	83 e0 01             	and    $0x1,%eax
  1034a3:	85 c0                	test   %eax,%eax
  1034a5:	74 13                	je     1034ba <get_page+0x4f>
        return pte2page(*ptep);
  1034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034aa:	8b 00                	mov    (%eax),%eax
  1034ac:	83 ec 0c             	sub    $0xc,%esp
  1034af:	50                   	push   %eax
  1034b0:	e8 57 f4 ff ff       	call   10290c <pte2page>
  1034b5:	83 c4 10             	add    $0x10,%esp
  1034b8:	eb 05                	jmp    1034bf <get_page+0x54>
    }
    return NULL;
  1034ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034bf:	c9                   	leave  
  1034c0:	c3                   	ret    

001034c1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034c1:	55                   	push   %ebp
  1034c2:	89 e5                	mov    %esp,%ebp
  1034c4:	83 ec 18             	sub    $0x18,%esp
#endif
    
    uintptr_t pdx, ptx, pt_pa;
    struct Page *rm_page_table; 
    
    pdx = PDX( la );
  1034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ca:	c1 e8 16             	shr    $0x16,%eax
  1034cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ptx = PTX( la );
  1034d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d3:	c1 e8 0c             	shr    $0xc,%eax
  1034d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  1034db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if( pgdir[ pdx ] & PTE_P )
  1034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1034eb:	01 d0                	add    %edx,%eax
  1034ed:	8b 00                	mov    (%eax),%eax
  1034ef:	83 e0 01             	and    $0x1,%eax
  1034f2:	85 c0                	test   %eax,%eax
  1034f4:	74 55                	je     10354b <page_remove_pte+0x8a>
    {
        rm_page_table = pte2page( *ptep ); 
  1034f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034f9:	8b 00                	mov    (%eax),%eax
  1034fb:	83 ec 0c             	sub    $0xc,%esp
  1034fe:	50                   	push   %eax
  1034ff:	e8 08 f4 ff ff       	call   10290c <pte2page>
  103504:	83 c4 10             	add    $0x10,%esp
  103507:	89 45 ec             	mov    %eax,-0x14(%ebp)
        page_ref_dec( rm_page_table );
  10350a:	83 ec 0c             	sub    $0xc,%esp
  10350d:	ff 75 ec             	pushl  -0x14(%ebp)
  103510:	e8 7c f4 ff ff       	call   102991 <page_ref_dec>
  103515:	83 c4 10             	add    $0x10,%esp

        if( rm_page_table->ref == 0 )
  103518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10351b:	8b 00                	mov    (%eax),%eax
  10351d:	85 c0                	test   %eax,%eax
  10351f:	75 10                	jne    103531 <page_remove_pte+0x70>
            free_page( rm_page_table );
  103521:	83 ec 08             	sub    $0x8,%esp
  103524:	6a 01                	push   $0x1
  103526:	ff 75 ec             	pushl  -0x14(%ebp)
  103529:	e8 80 f6 ff ff       	call   102bae <free_pages>
  10352e:	83 c4 10             	add    $0x10,%esp
        
        *ptep = NULL; 
  103531:	8b 45 10             	mov    0x10(%ebp),%eax
  103534:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate( pgdir, la );
  10353a:	83 ec 08             	sub    $0x8,%esp
  10353d:	ff 75 0c             	pushl  0xc(%ebp)
  103540:	ff 75 08             	pushl  0x8(%ebp)
  103543:	e8 f8 00 00 00       	call   103640 <tlb_invalidate>
  103548:	83 c4 10             	add    $0x10,%esp
    }
}
  10354b:	90                   	nop
  10354c:	c9                   	leave  
  10354d:	c3                   	ret    

0010354e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10354e:	55                   	push   %ebp
  10354f:	89 e5                	mov    %esp,%ebp
  103551:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103554:	83 ec 04             	sub    $0x4,%esp
  103557:	6a 00                	push   $0x0
  103559:	ff 75 0c             	pushl  0xc(%ebp)
  10355c:	ff 75 08             	pushl  0x8(%ebp)
  10355f:	e8 d4 fc ff ff       	call   103238 <get_pte>
  103564:	83 c4 10             	add    $0x10,%esp
  103567:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10356a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10356e:	74 14                	je     103584 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  103570:	83 ec 04             	sub    $0x4,%esp
  103573:	ff 75 f4             	pushl  -0xc(%ebp)
  103576:	ff 75 0c             	pushl  0xc(%ebp)
  103579:	ff 75 08             	pushl  0x8(%ebp)
  10357c:	e8 40 ff ff ff       	call   1034c1 <page_remove_pte>
  103581:	83 c4 10             	add    $0x10,%esp
    }
}
  103584:	90                   	nop
  103585:	c9                   	leave  
  103586:	c3                   	ret    

00103587 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103587:	55                   	push   %ebp
  103588:	89 e5                	mov    %esp,%ebp
  10358a:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10358d:	83 ec 04             	sub    $0x4,%esp
  103590:	6a 01                	push   $0x1
  103592:	ff 75 10             	pushl  0x10(%ebp)
  103595:	ff 75 08             	pushl  0x8(%ebp)
  103598:	e8 9b fc ff ff       	call   103238 <get_pte>
  10359d:	83 c4 10             	add    $0x10,%esp
  1035a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1035a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035a7:	75 0a                	jne    1035b3 <page_insert+0x2c>
        return -E_NO_MEM;
  1035a9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1035ae:	e9 8b 00 00 00       	jmp    10363e <page_insert+0xb7>
    }
    page_ref_inc(page);
  1035b3:	83 ec 0c             	sub    $0xc,%esp
  1035b6:	ff 75 0c             	pushl  0xc(%ebp)
  1035b9:	e8 bc f3 ff ff       	call   10297a <page_ref_inc>
  1035be:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  1035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035c4:	8b 00                	mov    (%eax),%eax
  1035c6:	83 e0 01             	and    $0x1,%eax
  1035c9:	85 c0                	test   %eax,%eax
  1035cb:	74 40                	je     10360d <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  1035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035d0:	8b 00                	mov    (%eax),%eax
  1035d2:	83 ec 0c             	sub    $0xc,%esp
  1035d5:	50                   	push   %eax
  1035d6:	e8 31 f3 ff ff       	call   10290c <pte2page>
  1035db:	83 c4 10             	add    $0x10,%esp
  1035de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1035e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1035e7:	75 10                	jne    1035f9 <page_insert+0x72>
            page_ref_dec(page);
  1035e9:	83 ec 0c             	sub    $0xc,%esp
  1035ec:	ff 75 0c             	pushl  0xc(%ebp)
  1035ef:	e8 9d f3 ff ff       	call   102991 <page_ref_dec>
  1035f4:	83 c4 10             	add    $0x10,%esp
  1035f7:	eb 14                	jmp    10360d <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1035f9:	83 ec 04             	sub    $0x4,%esp
  1035fc:	ff 75 f4             	pushl  -0xc(%ebp)
  1035ff:	ff 75 10             	pushl  0x10(%ebp)
  103602:	ff 75 08             	pushl  0x8(%ebp)
  103605:	e8 b7 fe ff ff       	call   1034c1 <page_remove_pte>
  10360a:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10360d:	83 ec 0c             	sub    $0xc,%esp
  103610:	ff 75 0c             	pushl  0xc(%ebp)
  103613:	e8 55 f2 ff ff       	call   10286d <page2pa>
  103618:	83 c4 10             	add    $0x10,%esp
  10361b:	0b 45 14             	or     0x14(%ebp),%eax
  10361e:	83 c8 01             	or     $0x1,%eax
  103621:	89 c2                	mov    %eax,%edx
  103623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103626:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103628:	83 ec 08             	sub    $0x8,%esp
  10362b:	ff 75 10             	pushl  0x10(%ebp)
  10362e:	ff 75 08             	pushl  0x8(%ebp)
  103631:	e8 0a 00 00 00       	call   103640 <tlb_invalidate>
  103636:	83 c4 10             	add    $0x10,%esp
    return 0;
  103639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10363e:	c9                   	leave  
  10363f:	c3                   	ret    

00103640 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103640:	55                   	push   %ebp
  103641:	89 e5                	mov    %esp,%ebp
  103643:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103646:	0f 20 d8             	mov    %cr3,%eax
  103649:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  10364c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10364f:	8b 45 08             	mov    0x8(%ebp),%eax
  103652:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103655:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10365c:	77 17                	ja     103675 <tlb_invalidate+0x35>
  10365e:	ff 75 f0             	pushl  -0x10(%ebp)
  103661:	68 24 66 10 00       	push   $0x106624
  103666:	68 05 02 00 00       	push   $0x205
  10366b:	68 48 66 10 00       	push   $0x106648
  103670:	e8 58 cd ff ff       	call   1003cd <__panic>
  103675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103678:	05 00 00 00 40       	add    $0x40000000,%eax
  10367d:	39 c2                	cmp    %eax,%edx
  10367f:	75 0c                	jne    10368d <tlb_invalidate+0x4d>
        invlpg((void *)la);
  103681:	8b 45 0c             	mov    0xc(%ebp),%eax
  103684:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10368a:	0f 01 38             	invlpg (%eax)
    }
}
  10368d:	90                   	nop
  10368e:	c9                   	leave  
  10368f:	c3                   	ret    

00103690 <check_alloc_page>:

static void
check_alloc_page(void) {
  103690:	55                   	push   %ebp
  103691:	89 e5                	mov    %esp,%ebp
  103693:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  103696:	a1 50 89 11 00       	mov    0x118950,%eax
  10369b:	8b 40 18             	mov    0x18(%eax),%eax
  10369e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1036a0:	83 ec 0c             	sub    $0xc,%esp
  1036a3:	68 20 67 10 00       	push   $0x106720
  1036a8:	e8 ba cb ff ff       	call   100267 <cprintf>
  1036ad:	83 c4 10             	add    $0x10,%esp
}
  1036b0:	90                   	nop
  1036b1:	c9                   	leave  
  1036b2:	c3                   	ret    

001036b3 <check_pgdir>:

static void
check_pgdir(void) {
  1036b3:	55                   	push   %ebp
  1036b4:	89 e5                	mov    %esp,%ebp
  1036b6:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036b9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1036be:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1036c3:	76 19                	jbe    1036de <check_pgdir+0x2b>
  1036c5:	68 3f 67 10 00       	push   $0x10673f
  1036ca:	68 6d 66 10 00       	push   $0x10666d
  1036cf:	68 12 02 00 00       	push   $0x212
  1036d4:	68 48 66 10 00       	push   $0x106648
  1036d9:	e8 ef cc ff ff       	call   1003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1036de:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036e3:	85 c0                	test   %eax,%eax
  1036e5:	74 0e                	je     1036f5 <check_pgdir+0x42>
  1036e7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036ec:	25 ff 0f 00 00       	and    $0xfff,%eax
  1036f1:	85 c0                	test   %eax,%eax
  1036f3:	74 19                	je     10370e <check_pgdir+0x5b>
  1036f5:	68 5c 67 10 00       	push   $0x10675c
  1036fa:	68 6d 66 10 00       	push   $0x10666d
  1036ff:	68 13 02 00 00       	push   $0x213
  103704:	68 48 66 10 00       	push   $0x106648
  103709:	e8 bf cc ff ff       	call   1003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10370e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103713:	83 ec 04             	sub    $0x4,%esp
  103716:	6a 00                	push   $0x0
  103718:	6a 00                	push   $0x0
  10371a:	50                   	push   %eax
  10371b:	e8 4b fd ff ff       	call   10346b <get_page>
  103720:	83 c4 10             	add    $0x10,%esp
  103723:	85 c0                	test   %eax,%eax
  103725:	74 19                	je     103740 <check_pgdir+0x8d>
  103727:	68 94 67 10 00       	push   $0x106794
  10372c:	68 6d 66 10 00       	push   $0x10666d
  103731:	68 14 02 00 00       	push   $0x214
  103736:	68 48 66 10 00       	push   $0x106648
  10373b:	e8 8d cc ff ff       	call   1003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103740:	83 ec 0c             	sub    $0xc,%esp
  103743:	6a 01                	push   $0x1
  103745:	e8 26 f4 ff ff       	call   102b70 <alloc_pages>
  10374a:	83 c4 10             	add    $0x10,%esp
  10374d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103750:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103755:	6a 00                	push   $0x0
  103757:	6a 00                	push   $0x0
  103759:	ff 75 f4             	pushl  -0xc(%ebp)
  10375c:	50                   	push   %eax
  10375d:	e8 25 fe ff ff       	call   103587 <page_insert>
  103762:	83 c4 10             	add    $0x10,%esp
  103765:	85 c0                	test   %eax,%eax
  103767:	74 19                	je     103782 <check_pgdir+0xcf>
  103769:	68 bc 67 10 00       	push   $0x1067bc
  10376e:	68 6d 66 10 00       	push   $0x10666d
  103773:	68 18 02 00 00       	push   $0x218
  103778:	68 48 66 10 00       	push   $0x106648
  10377d:	e8 4b cc ff ff       	call   1003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103782:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103787:	83 ec 04             	sub    $0x4,%esp
  10378a:	6a 00                	push   $0x0
  10378c:	6a 00                	push   $0x0
  10378e:	50                   	push   %eax
  10378f:	e8 a4 fa ff ff       	call   103238 <get_pte>
  103794:	83 c4 10             	add    $0x10,%esp
  103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10379a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10379e:	75 19                	jne    1037b9 <check_pgdir+0x106>
  1037a0:	68 e8 67 10 00       	push   $0x1067e8
  1037a5:	68 6d 66 10 00       	push   $0x10666d
  1037aa:	68 1b 02 00 00       	push   $0x21b
  1037af:	68 48 66 10 00       	push   $0x106648
  1037b4:	e8 14 cc ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  1037b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037bc:	8b 00                	mov    (%eax),%eax
  1037be:	83 ec 0c             	sub    $0xc,%esp
  1037c1:	50                   	push   %eax
  1037c2:	e8 45 f1 ff ff       	call   10290c <pte2page>
  1037c7:	83 c4 10             	add    $0x10,%esp
  1037ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1037cd:	74 19                	je     1037e8 <check_pgdir+0x135>
  1037cf:	68 15 68 10 00       	push   $0x106815
  1037d4:	68 6d 66 10 00       	push   $0x10666d
  1037d9:	68 1c 02 00 00       	push   $0x21c
  1037de:	68 48 66 10 00       	push   $0x106648
  1037e3:	e8 e5 cb ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 1);
  1037e8:	83 ec 0c             	sub    $0xc,%esp
  1037eb:	ff 75 f4             	pushl  -0xc(%ebp)
  1037ee:	e8 6f f1 ff ff       	call   102962 <page_ref>
  1037f3:	83 c4 10             	add    $0x10,%esp
  1037f6:	83 f8 01             	cmp    $0x1,%eax
  1037f9:	74 19                	je     103814 <check_pgdir+0x161>
  1037fb:	68 2b 68 10 00       	push   $0x10682b
  103800:	68 6d 66 10 00       	push   $0x10666d
  103805:	68 1d 02 00 00       	push   $0x21d
  10380a:	68 48 66 10 00       	push   $0x106648
  10380f:	e8 b9 cb ff ff       	call   1003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103814:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103819:	8b 00                	mov    (%eax),%eax
  10381b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103826:	c1 e8 0c             	shr    $0xc,%eax
  103829:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10382c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103831:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103834:	72 17                	jb     10384d <check_pgdir+0x19a>
  103836:	ff 75 ec             	pushl  -0x14(%ebp)
  103839:	68 80 65 10 00       	push   $0x106580
  10383e:	68 1f 02 00 00       	push   $0x21f
  103843:	68 48 66 10 00       	push   $0x106648
  103848:	e8 80 cb ff ff       	call   1003cd <__panic>
  10384d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103850:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103855:	83 c0 04             	add    $0x4,%eax
  103858:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10385b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103860:	83 ec 04             	sub    $0x4,%esp
  103863:	6a 00                	push   $0x0
  103865:	68 00 10 00 00       	push   $0x1000
  10386a:	50                   	push   %eax
  10386b:	e8 c8 f9 ff ff       	call   103238 <get_pte>
  103870:	83 c4 10             	add    $0x10,%esp
  103873:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103876:	74 19                	je     103891 <check_pgdir+0x1de>
  103878:	68 40 68 10 00       	push   $0x106840
  10387d:	68 6d 66 10 00       	push   $0x10666d
  103882:	68 20 02 00 00       	push   $0x220
  103887:	68 48 66 10 00       	push   $0x106648
  10388c:	e8 3c cb ff ff       	call   1003cd <__panic>

    p2 = alloc_page();
  103891:	83 ec 0c             	sub    $0xc,%esp
  103894:	6a 01                	push   $0x1
  103896:	e8 d5 f2 ff ff       	call   102b70 <alloc_pages>
  10389b:	83 c4 10             	add    $0x10,%esp
  10389e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1038a1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038a6:	6a 06                	push   $0x6
  1038a8:	68 00 10 00 00       	push   $0x1000
  1038ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  1038b0:	50                   	push   %eax
  1038b1:	e8 d1 fc ff ff       	call   103587 <page_insert>
  1038b6:	83 c4 10             	add    $0x10,%esp
  1038b9:	85 c0                	test   %eax,%eax
  1038bb:	74 19                	je     1038d6 <check_pgdir+0x223>
  1038bd:	68 68 68 10 00       	push   $0x106868
  1038c2:	68 6d 66 10 00       	push   $0x10666d
  1038c7:	68 23 02 00 00       	push   $0x223
  1038cc:	68 48 66 10 00       	push   $0x106648
  1038d1:	e8 f7 ca ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1038d6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038db:	83 ec 04             	sub    $0x4,%esp
  1038de:	6a 00                	push   $0x0
  1038e0:	68 00 10 00 00       	push   $0x1000
  1038e5:	50                   	push   %eax
  1038e6:	e8 4d f9 ff ff       	call   103238 <get_pte>
  1038eb:	83 c4 10             	add    $0x10,%esp
  1038ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038f5:	75 19                	jne    103910 <check_pgdir+0x25d>
  1038f7:	68 a0 68 10 00       	push   $0x1068a0
  1038fc:	68 6d 66 10 00       	push   $0x10666d
  103901:	68 24 02 00 00       	push   $0x224
  103906:	68 48 66 10 00       	push   $0x106648
  10390b:	e8 bd ca ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_U);
  103910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103913:	8b 00                	mov    (%eax),%eax
  103915:	83 e0 04             	and    $0x4,%eax
  103918:	85 c0                	test   %eax,%eax
  10391a:	75 19                	jne    103935 <check_pgdir+0x282>
  10391c:	68 d0 68 10 00       	push   $0x1068d0
  103921:	68 6d 66 10 00       	push   $0x10666d
  103926:	68 25 02 00 00       	push   $0x225
  10392b:	68 48 66 10 00       	push   $0x106648
  103930:	e8 98 ca ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_W);
  103935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103938:	8b 00                	mov    (%eax),%eax
  10393a:	83 e0 02             	and    $0x2,%eax
  10393d:	85 c0                	test   %eax,%eax
  10393f:	75 19                	jne    10395a <check_pgdir+0x2a7>
  103941:	68 de 68 10 00       	push   $0x1068de
  103946:	68 6d 66 10 00       	push   $0x10666d
  10394b:	68 26 02 00 00       	push   $0x226
  103950:	68 48 66 10 00       	push   $0x106648
  103955:	e8 73 ca ff ff       	call   1003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  10395a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10395f:	8b 00                	mov    (%eax),%eax
  103961:	83 e0 04             	and    $0x4,%eax
  103964:	85 c0                	test   %eax,%eax
  103966:	75 19                	jne    103981 <check_pgdir+0x2ce>
  103968:	68 ec 68 10 00       	push   $0x1068ec
  10396d:	68 6d 66 10 00       	push   $0x10666d
  103972:	68 27 02 00 00       	push   $0x227
  103977:	68 48 66 10 00       	push   $0x106648
  10397c:	e8 4c ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 1);
  103981:	83 ec 0c             	sub    $0xc,%esp
  103984:	ff 75 e4             	pushl  -0x1c(%ebp)
  103987:	e8 d6 ef ff ff       	call   102962 <page_ref>
  10398c:	83 c4 10             	add    $0x10,%esp
  10398f:	83 f8 01             	cmp    $0x1,%eax
  103992:	74 19                	je     1039ad <check_pgdir+0x2fa>
  103994:	68 02 69 10 00       	push   $0x106902
  103999:	68 6d 66 10 00       	push   $0x10666d
  10399e:	68 28 02 00 00       	push   $0x228
  1039a3:	68 48 66 10 00       	push   $0x106648
  1039a8:	e8 20 ca ff ff       	call   1003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1039ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039b2:	6a 00                	push   $0x0
  1039b4:	68 00 10 00 00       	push   $0x1000
  1039b9:	ff 75 f4             	pushl  -0xc(%ebp)
  1039bc:	50                   	push   %eax
  1039bd:	e8 c5 fb ff ff       	call   103587 <page_insert>
  1039c2:	83 c4 10             	add    $0x10,%esp
  1039c5:	85 c0                	test   %eax,%eax
  1039c7:	74 19                	je     1039e2 <check_pgdir+0x32f>
  1039c9:	68 14 69 10 00       	push   $0x106914
  1039ce:	68 6d 66 10 00       	push   $0x10666d
  1039d3:	68 2a 02 00 00       	push   $0x22a
  1039d8:	68 48 66 10 00       	push   $0x106648
  1039dd:	e8 eb c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 2);
  1039e2:	83 ec 0c             	sub    $0xc,%esp
  1039e5:	ff 75 f4             	pushl  -0xc(%ebp)
  1039e8:	e8 75 ef ff ff       	call   102962 <page_ref>
  1039ed:	83 c4 10             	add    $0x10,%esp
  1039f0:	83 f8 02             	cmp    $0x2,%eax
  1039f3:	74 19                	je     103a0e <check_pgdir+0x35b>
  1039f5:	68 40 69 10 00       	push   $0x106940
  1039fa:	68 6d 66 10 00       	push   $0x10666d
  1039ff:	68 2b 02 00 00       	push   $0x22b
  103a04:	68 48 66 10 00       	push   $0x106648
  103a09:	e8 bf c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103a0e:	83 ec 0c             	sub    $0xc,%esp
  103a11:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a14:	e8 49 ef ff ff       	call   102962 <page_ref>
  103a19:	83 c4 10             	add    $0x10,%esp
  103a1c:	85 c0                	test   %eax,%eax
  103a1e:	74 19                	je     103a39 <check_pgdir+0x386>
  103a20:	68 52 69 10 00       	push   $0x106952
  103a25:	68 6d 66 10 00       	push   $0x10666d
  103a2a:	68 2c 02 00 00       	push   $0x22c
  103a2f:	68 48 66 10 00       	push   $0x106648
  103a34:	e8 94 c9 ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a39:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a3e:	83 ec 04             	sub    $0x4,%esp
  103a41:	6a 00                	push   $0x0
  103a43:	68 00 10 00 00       	push   $0x1000
  103a48:	50                   	push   %eax
  103a49:	e8 ea f7 ff ff       	call   103238 <get_pte>
  103a4e:	83 c4 10             	add    $0x10,%esp
  103a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a58:	75 19                	jne    103a73 <check_pgdir+0x3c0>
  103a5a:	68 a0 68 10 00       	push   $0x1068a0
  103a5f:	68 6d 66 10 00       	push   $0x10666d
  103a64:	68 2d 02 00 00       	push   $0x22d
  103a69:	68 48 66 10 00       	push   $0x106648
  103a6e:	e8 5a c9 ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  103a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a76:	8b 00                	mov    (%eax),%eax
  103a78:	83 ec 0c             	sub    $0xc,%esp
  103a7b:	50                   	push   %eax
  103a7c:	e8 8b ee ff ff       	call   10290c <pte2page>
  103a81:	83 c4 10             	add    $0x10,%esp
  103a84:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103a87:	74 19                	je     103aa2 <check_pgdir+0x3ef>
  103a89:	68 15 68 10 00       	push   $0x106815
  103a8e:	68 6d 66 10 00       	push   $0x10666d
  103a93:	68 2e 02 00 00       	push   $0x22e
  103a98:	68 48 66 10 00       	push   $0x106648
  103a9d:	e8 2b c9 ff ff       	call   1003cd <__panic>
    assert((*ptep & PTE_U) == 0);
  103aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aa5:	8b 00                	mov    (%eax),%eax
  103aa7:	83 e0 04             	and    $0x4,%eax
  103aaa:	85 c0                	test   %eax,%eax
  103aac:	74 19                	je     103ac7 <check_pgdir+0x414>
  103aae:	68 64 69 10 00       	push   $0x106964
  103ab3:	68 6d 66 10 00       	push   $0x10666d
  103ab8:	68 2f 02 00 00       	push   $0x22f
  103abd:	68 48 66 10 00       	push   $0x106648
  103ac2:	e8 06 c9 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, 0x0);
  103ac7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103acc:	83 ec 08             	sub    $0x8,%esp
  103acf:	6a 00                	push   $0x0
  103ad1:	50                   	push   %eax
  103ad2:	e8 77 fa ff ff       	call   10354e <page_remove>
  103ad7:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103ada:	83 ec 0c             	sub    $0xc,%esp
  103add:	ff 75 f4             	pushl  -0xc(%ebp)
  103ae0:	e8 7d ee ff ff       	call   102962 <page_ref>
  103ae5:	83 c4 10             	add    $0x10,%esp
  103ae8:	83 f8 01             	cmp    $0x1,%eax
  103aeb:	74 19                	je     103b06 <check_pgdir+0x453>
  103aed:	68 2b 68 10 00       	push   $0x10682b
  103af2:	68 6d 66 10 00       	push   $0x10666d
  103af7:	68 32 02 00 00       	push   $0x232
  103afc:	68 48 66 10 00       	push   $0x106648
  103b01:	e8 c7 c8 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103b06:	83 ec 0c             	sub    $0xc,%esp
  103b09:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b0c:	e8 51 ee ff ff       	call   102962 <page_ref>
  103b11:	83 c4 10             	add    $0x10,%esp
  103b14:	85 c0                	test   %eax,%eax
  103b16:	74 19                	je     103b31 <check_pgdir+0x47e>
  103b18:	68 52 69 10 00       	push   $0x106952
  103b1d:	68 6d 66 10 00       	push   $0x10666d
  103b22:	68 33 02 00 00       	push   $0x233
  103b27:	68 48 66 10 00       	push   $0x106648
  103b2c:	e8 9c c8 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b31:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b36:	83 ec 08             	sub    $0x8,%esp
  103b39:	68 00 10 00 00       	push   $0x1000
  103b3e:	50                   	push   %eax
  103b3f:	e8 0a fa ff ff       	call   10354e <page_remove>
  103b44:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103b47:	83 ec 0c             	sub    $0xc,%esp
  103b4a:	ff 75 f4             	pushl  -0xc(%ebp)
  103b4d:	e8 10 ee ff ff       	call   102962 <page_ref>
  103b52:	83 c4 10             	add    $0x10,%esp
  103b55:	85 c0                	test   %eax,%eax
  103b57:	74 19                	je     103b72 <check_pgdir+0x4bf>
  103b59:	68 79 69 10 00       	push   $0x106979
  103b5e:	68 6d 66 10 00       	push   $0x10666d
  103b63:	68 36 02 00 00       	push   $0x236
  103b68:	68 48 66 10 00       	push   $0x106648
  103b6d:	e8 5b c8 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103b72:	83 ec 0c             	sub    $0xc,%esp
  103b75:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b78:	e8 e5 ed ff ff       	call   102962 <page_ref>
  103b7d:	83 c4 10             	add    $0x10,%esp
  103b80:	85 c0                	test   %eax,%eax
  103b82:	74 19                	je     103b9d <check_pgdir+0x4ea>
  103b84:	68 52 69 10 00       	push   $0x106952
  103b89:	68 6d 66 10 00       	push   $0x10666d
  103b8e:	68 37 02 00 00       	push   $0x237
  103b93:	68 48 66 10 00       	push   $0x106648
  103b98:	e8 30 c8 ff ff       	call   1003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103b9d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ba2:	8b 00                	mov    (%eax),%eax
  103ba4:	83 ec 0c             	sub    $0xc,%esp
  103ba7:	50                   	push   %eax
  103ba8:	e8 99 ed ff ff       	call   102946 <pde2page>
  103bad:	83 c4 10             	add    $0x10,%esp
  103bb0:	83 ec 0c             	sub    $0xc,%esp
  103bb3:	50                   	push   %eax
  103bb4:	e8 a9 ed ff ff       	call   102962 <page_ref>
  103bb9:	83 c4 10             	add    $0x10,%esp
  103bbc:	83 f8 01             	cmp    $0x1,%eax
  103bbf:	74 19                	je     103bda <check_pgdir+0x527>
  103bc1:	68 8c 69 10 00       	push   $0x10698c
  103bc6:	68 6d 66 10 00       	push   $0x10666d
  103bcb:	68 39 02 00 00       	push   $0x239
  103bd0:	68 48 66 10 00       	push   $0x106648
  103bd5:	e8 f3 c7 ff ff       	call   1003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103bda:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bdf:	8b 00                	mov    (%eax),%eax
  103be1:	83 ec 0c             	sub    $0xc,%esp
  103be4:	50                   	push   %eax
  103be5:	e8 5c ed ff ff       	call   102946 <pde2page>
  103bea:	83 c4 10             	add    $0x10,%esp
  103bed:	83 ec 08             	sub    $0x8,%esp
  103bf0:	6a 01                	push   $0x1
  103bf2:	50                   	push   %eax
  103bf3:	e8 b6 ef ff ff       	call   102bae <free_pages>
  103bf8:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103bfb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c06:	83 ec 0c             	sub    $0xc,%esp
  103c09:	68 b3 69 10 00       	push   $0x1069b3
  103c0e:	e8 54 c6 ff ff       	call   100267 <cprintf>
  103c13:	83 c4 10             	add    $0x10,%esp
}
  103c16:	90                   	nop
  103c17:	c9                   	leave  
  103c18:	c3                   	ret    

00103c19 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c19:	55                   	push   %ebp
  103c1a:	89 e5                	mov    %esp,%ebp
  103c1c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c26:	e9 a3 00 00 00       	jmp    103cce <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c34:	c1 e8 0c             	shr    $0xc,%eax
  103c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c3a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c3f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103c42:	72 17                	jb     103c5b <check_boot_pgdir+0x42>
  103c44:	ff 75 f0             	pushl  -0x10(%ebp)
  103c47:	68 80 65 10 00       	push   $0x106580
  103c4c:	68 45 02 00 00       	push   $0x245
  103c51:	68 48 66 10 00       	push   $0x106648
  103c56:	e8 72 c7 ff ff       	call   1003cd <__panic>
  103c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c5e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103c63:	89 c2                	mov    %eax,%edx
  103c65:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c6a:	83 ec 04             	sub    $0x4,%esp
  103c6d:	6a 00                	push   $0x0
  103c6f:	52                   	push   %edx
  103c70:	50                   	push   %eax
  103c71:	e8 c2 f5 ff ff       	call   103238 <get_pte>
  103c76:	83 c4 10             	add    $0x10,%esp
  103c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103c7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103c80:	75 19                	jne    103c9b <check_boot_pgdir+0x82>
  103c82:	68 d0 69 10 00       	push   $0x1069d0
  103c87:	68 6d 66 10 00       	push   $0x10666d
  103c8c:	68 45 02 00 00       	push   $0x245
  103c91:	68 48 66 10 00       	push   $0x106648
  103c96:	e8 32 c7 ff ff       	call   1003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103c9e:	8b 00                	mov    (%eax),%eax
  103ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ca5:	89 c2                	mov    %eax,%edx
  103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103caa:	39 c2                	cmp    %eax,%edx
  103cac:	74 19                	je     103cc7 <check_boot_pgdir+0xae>
  103cae:	68 0d 6a 10 00       	push   $0x106a0d
  103cb3:	68 6d 66 10 00       	push   $0x10666d
  103cb8:	68 46 02 00 00       	push   $0x246
  103cbd:	68 48 66 10 00       	push   $0x106648
  103cc2:	e8 06 c7 ff ff       	call   1003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103cc7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103cd1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103cd6:	39 c2                	cmp    %eax,%edx
  103cd8:	0f 82 4d ff ff ff    	jb     103c2b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103cde:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ce3:	05 ac 0f 00 00       	add    $0xfac,%eax
  103ce8:	8b 00                	mov    (%eax),%eax
  103cea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cef:	89 c2                	mov    %eax,%edx
  103cf1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103cf9:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103d00:	77 17                	ja     103d19 <check_boot_pgdir+0x100>
  103d02:	ff 75 e4             	pushl  -0x1c(%ebp)
  103d05:	68 24 66 10 00       	push   $0x106624
  103d0a:	68 49 02 00 00       	push   $0x249
  103d0f:	68 48 66 10 00       	push   $0x106648
  103d14:	e8 b4 c6 ff ff       	call   1003cd <__panic>
  103d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d1c:	05 00 00 00 40       	add    $0x40000000,%eax
  103d21:	39 c2                	cmp    %eax,%edx
  103d23:	74 19                	je     103d3e <check_boot_pgdir+0x125>
  103d25:	68 24 6a 10 00       	push   $0x106a24
  103d2a:	68 6d 66 10 00       	push   $0x10666d
  103d2f:	68 49 02 00 00       	push   $0x249
  103d34:	68 48 66 10 00       	push   $0x106648
  103d39:	e8 8f c6 ff ff       	call   1003cd <__panic>

    assert(boot_pgdir[0] == 0);
  103d3e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d43:	8b 00                	mov    (%eax),%eax
  103d45:	85 c0                	test   %eax,%eax
  103d47:	74 19                	je     103d62 <check_boot_pgdir+0x149>
  103d49:	68 58 6a 10 00       	push   $0x106a58
  103d4e:	68 6d 66 10 00       	push   $0x10666d
  103d53:	68 4b 02 00 00       	push   $0x24b
  103d58:	68 48 66 10 00       	push   $0x106648
  103d5d:	e8 6b c6 ff ff       	call   1003cd <__panic>

    struct Page *p;
    p = alloc_page();
  103d62:	83 ec 0c             	sub    $0xc,%esp
  103d65:	6a 01                	push   $0x1
  103d67:	e8 04 ee ff ff       	call   102b70 <alloc_pages>
  103d6c:	83 c4 10             	add    $0x10,%esp
  103d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103d72:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d77:	6a 02                	push   $0x2
  103d79:	68 00 01 00 00       	push   $0x100
  103d7e:	ff 75 e0             	pushl  -0x20(%ebp)
  103d81:	50                   	push   %eax
  103d82:	e8 00 f8 ff ff       	call   103587 <page_insert>
  103d87:	83 c4 10             	add    $0x10,%esp
  103d8a:	85 c0                	test   %eax,%eax
  103d8c:	74 19                	je     103da7 <check_boot_pgdir+0x18e>
  103d8e:	68 6c 6a 10 00       	push   $0x106a6c
  103d93:	68 6d 66 10 00       	push   $0x10666d
  103d98:	68 4f 02 00 00       	push   $0x24f
  103d9d:	68 48 66 10 00       	push   $0x106648
  103da2:	e8 26 c6 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 1);
  103da7:	83 ec 0c             	sub    $0xc,%esp
  103daa:	ff 75 e0             	pushl  -0x20(%ebp)
  103dad:	e8 b0 eb ff ff       	call   102962 <page_ref>
  103db2:	83 c4 10             	add    $0x10,%esp
  103db5:	83 f8 01             	cmp    $0x1,%eax
  103db8:	74 19                	je     103dd3 <check_boot_pgdir+0x1ba>
  103dba:	68 9a 6a 10 00       	push   $0x106a9a
  103dbf:	68 6d 66 10 00       	push   $0x10666d
  103dc4:	68 50 02 00 00       	push   $0x250
  103dc9:	68 48 66 10 00       	push   $0x106648
  103dce:	e8 fa c5 ff ff       	call   1003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103dd3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103dd8:	6a 02                	push   $0x2
  103dda:	68 00 11 00 00       	push   $0x1100
  103ddf:	ff 75 e0             	pushl  -0x20(%ebp)
  103de2:	50                   	push   %eax
  103de3:	e8 9f f7 ff ff       	call   103587 <page_insert>
  103de8:	83 c4 10             	add    $0x10,%esp
  103deb:	85 c0                	test   %eax,%eax
  103ded:	74 19                	je     103e08 <check_boot_pgdir+0x1ef>
  103def:	68 ac 6a 10 00       	push   $0x106aac
  103df4:	68 6d 66 10 00       	push   $0x10666d
  103df9:	68 51 02 00 00       	push   $0x251
  103dfe:	68 48 66 10 00       	push   $0x106648
  103e03:	e8 c5 c5 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 2);
  103e08:	83 ec 0c             	sub    $0xc,%esp
  103e0b:	ff 75 e0             	pushl  -0x20(%ebp)
  103e0e:	e8 4f eb ff ff       	call   102962 <page_ref>
  103e13:	83 c4 10             	add    $0x10,%esp
  103e16:	83 f8 02             	cmp    $0x2,%eax
  103e19:	74 19                	je     103e34 <check_boot_pgdir+0x21b>
  103e1b:	68 e3 6a 10 00       	push   $0x106ae3
  103e20:	68 6d 66 10 00       	push   $0x10666d
  103e25:	68 52 02 00 00       	push   $0x252
  103e2a:	68 48 66 10 00       	push   $0x106648
  103e2f:	e8 99 c5 ff ff       	call   1003cd <__panic>

    const char *str = "ucore: Hello world!!";
  103e34:	c7 45 dc f4 6a 10 00 	movl   $0x106af4,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103e3b:	83 ec 08             	sub    $0x8,%esp
  103e3e:	ff 75 dc             	pushl  -0x24(%ebp)
  103e41:	68 00 01 00 00       	push   $0x100
  103e46:	e8 72 15 00 00       	call   1053bd <strcpy>
  103e4b:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103e4e:	83 ec 08             	sub    $0x8,%esp
  103e51:	68 00 11 00 00       	push   $0x1100
  103e56:	68 00 01 00 00       	push   $0x100
  103e5b:	e8 d7 15 00 00       	call   105437 <strcmp>
  103e60:	83 c4 10             	add    $0x10,%esp
  103e63:	85 c0                	test   %eax,%eax
  103e65:	74 19                	je     103e80 <check_boot_pgdir+0x267>
  103e67:	68 0c 6b 10 00       	push   $0x106b0c
  103e6c:	68 6d 66 10 00       	push   $0x10666d
  103e71:	68 56 02 00 00       	push   $0x256
  103e76:	68 48 66 10 00       	push   $0x106648
  103e7b:	e8 4d c5 ff ff       	call   1003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103e80:	83 ec 0c             	sub    $0xc,%esp
  103e83:	ff 75 e0             	pushl  -0x20(%ebp)
  103e86:	e8 3c ea ff ff       	call   1028c7 <page2kva>
  103e8b:	83 c4 10             	add    $0x10,%esp
  103e8e:	05 00 01 00 00       	add    $0x100,%eax
  103e93:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103e96:	83 ec 0c             	sub    $0xc,%esp
  103e99:	68 00 01 00 00       	push   $0x100
  103e9e:	e8 c2 14 00 00       	call   105365 <strlen>
  103ea3:	83 c4 10             	add    $0x10,%esp
  103ea6:	85 c0                	test   %eax,%eax
  103ea8:	74 19                	je     103ec3 <check_boot_pgdir+0x2aa>
  103eaa:	68 44 6b 10 00       	push   $0x106b44
  103eaf:	68 6d 66 10 00       	push   $0x10666d
  103eb4:	68 59 02 00 00       	push   $0x259
  103eb9:	68 48 66 10 00       	push   $0x106648
  103ebe:	e8 0a c5 ff ff       	call   1003cd <__panic>

    free_page(p);
  103ec3:	83 ec 08             	sub    $0x8,%esp
  103ec6:	6a 01                	push   $0x1
  103ec8:	ff 75 e0             	pushl  -0x20(%ebp)
  103ecb:	e8 de ec ff ff       	call   102bae <free_pages>
  103ed0:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103ed3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ed8:	8b 00                	mov    (%eax),%eax
  103eda:	83 ec 0c             	sub    $0xc,%esp
  103edd:	50                   	push   %eax
  103ede:	e8 63 ea ff ff       	call   102946 <pde2page>
  103ee3:	83 c4 10             	add    $0x10,%esp
  103ee6:	83 ec 08             	sub    $0x8,%esp
  103ee9:	6a 01                	push   $0x1
  103eeb:	50                   	push   %eax
  103eec:	e8 bd ec ff ff       	call   102bae <free_pages>
  103ef1:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103ef4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103eff:	83 ec 0c             	sub    $0xc,%esp
  103f02:	68 68 6b 10 00       	push   $0x106b68
  103f07:	e8 5b c3 ff ff       	call   100267 <cprintf>
  103f0c:	83 c4 10             	add    $0x10,%esp
}
  103f0f:	90                   	nop
  103f10:	c9                   	leave  
  103f11:	c3                   	ret    

00103f12 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103f12:	55                   	push   %ebp
  103f13:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103f15:	8b 45 08             	mov    0x8(%ebp),%eax
  103f18:	83 e0 04             	and    $0x4,%eax
  103f1b:	85 c0                	test   %eax,%eax
  103f1d:	74 07                	je     103f26 <perm2str+0x14>
  103f1f:	b8 75 00 00 00       	mov    $0x75,%eax
  103f24:	eb 05                	jmp    103f2b <perm2str+0x19>
  103f26:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f2b:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103f30:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103f37:	8b 45 08             	mov    0x8(%ebp),%eax
  103f3a:	83 e0 02             	and    $0x2,%eax
  103f3d:	85 c0                	test   %eax,%eax
  103f3f:	74 07                	je     103f48 <perm2str+0x36>
  103f41:	b8 77 00 00 00       	mov    $0x77,%eax
  103f46:	eb 05                	jmp    103f4d <perm2str+0x3b>
  103f48:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f4d:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103f52:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103f59:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103f5e:	5d                   	pop    %ebp
  103f5f:	c3                   	ret    

00103f60 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103f60:	55                   	push   %ebp
  103f61:	89 e5                	mov    %esp,%ebp
  103f63:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103f66:	8b 45 10             	mov    0x10(%ebp),%eax
  103f69:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f6c:	72 0e                	jb     103f7c <get_pgtable_items+0x1c>
        return 0;
  103f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  103f73:	e9 9a 00 00 00       	jmp    104012 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103f78:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  103f7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f82:	73 18                	jae    103f9c <get_pgtable_items+0x3c>
  103f84:	8b 45 10             	mov    0x10(%ebp),%eax
  103f87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  103f91:	01 d0                	add    %edx,%eax
  103f93:	8b 00                	mov    (%eax),%eax
  103f95:	83 e0 01             	and    $0x1,%eax
  103f98:	85 c0                	test   %eax,%eax
  103f9a:	74 dc                	je     103f78 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  103f9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fa2:	73 69                	jae    10400d <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103fa4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103fa8:	74 08                	je     103fb2 <get_pgtable_items+0x52>
            *left_store = start;
  103faa:	8b 45 18             	mov    0x18(%ebp),%eax
  103fad:	8b 55 10             	mov    0x10(%ebp),%edx
  103fb0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  103fb5:	8d 50 01             	lea    0x1(%eax),%edx
  103fb8:	89 55 10             	mov    %edx,0x10(%ebp)
  103fbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  103fc5:	01 d0                	add    %edx,%eax
  103fc7:	8b 00                	mov    (%eax),%eax
  103fc9:	83 e0 07             	and    $0x7,%eax
  103fcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fcf:	eb 04                	jmp    103fd5 <get_pgtable_items+0x75>
            start ++;
  103fd1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  103fd8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fdb:	73 1d                	jae    103ffa <get_pgtable_items+0x9a>
  103fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  103fe0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  103fea:	01 d0                	add    %edx,%eax
  103fec:	8b 00                	mov    (%eax),%eax
  103fee:	83 e0 07             	and    $0x7,%eax
  103ff1:	89 c2                	mov    %eax,%edx
  103ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103ff6:	39 c2                	cmp    %eax,%edx
  103ff8:	74 d7                	je     103fd1 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103ffa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103ffe:	74 08                	je     104008 <get_pgtable_items+0xa8>
            *right_store = start;
  104000:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104003:	8b 55 10             	mov    0x10(%ebp),%edx
  104006:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10400b:	eb 05                	jmp    104012 <get_pgtable_items+0xb2>
    }
    return 0;
  10400d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104012:	c9                   	leave  
  104013:	c3                   	ret    

00104014 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104014:	55                   	push   %ebp
  104015:	89 e5                	mov    %esp,%ebp
  104017:	57                   	push   %edi
  104018:	56                   	push   %esi
  104019:	53                   	push   %ebx
  10401a:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10401d:	83 ec 0c             	sub    $0xc,%esp
  104020:	68 88 6b 10 00       	push   $0x106b88
  104025:	e8 3d c2 ff ff       	call   100267 <cprintf>
  10402a:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  10402d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104034:	e9 e5 00 00 00       	jmp    10411e <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10403c:	83 ec 0c             	sub    $0xc,%esp
  10403f:	50                   	push   %eax
  104040:	e8 cd fe ff ff       	call   103f12 <perm2str>
  104045:	83 c4 10             	add    $0x10,%esp
  104048:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10404a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10404d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104050:	29 c2                	sub    %eax,%edx
  104052:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104054:	c1 e0 16             	shl    $0x16,%eax
  104057:	89 c3                	mov    %eax,%ebx
  104059:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10405c:	c1 e0 16             	shl    $0x16,%eax
  10405f:	89 c1                	mov    %eax,%ecx
  104061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104064:	c1 e0 16             	shl    $0x16,%eax
  104067:	89 c2                	mov    %eax,%edx
  104069:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10406c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10406f:	29 c6                	sub    %eax,%esi
  104071:	89 f0                	mov    %esi,%eax
  104073:	83 ec 08             	sub    $0x8,%esp
  104076:	57                   	push   %edi
  104077:	53                   	push   %ebx
  104078:	51                   	push   %ecx
  104079:	52                   	push   %edx
  10407a:	50                   	push   %eax
  10407b:	68 b9 6b 10 00       	push   $0x106bb9
  104080:	e8 e2 c1 ff ff       	call   100267 <cprintf>
  104085:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10408b:	c1 e0 0a             	shl    $0xa,%eax
  10408e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104091:	eb 4f                	jmp    1040e2 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104096:	83 ec 0c             	sub    $0xc,%esp
  104099:	50                   	push   %eax
  10409a:	e8 73 fe ff ff       	call   103f12 <perm2str>
  10409f:	83 c4 10             	add    $0x10,%esp
  1040a2:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1040a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040aa:	29 c2                	sub    %eax,%edx
  1040ac:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1040ae:	c1 e0 0c             	shl    $0xc,%eax
  1040b1:	89 c3                	mov    %eax,%ebx
  1040b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040b6:	c1 e0 0c             	shl    $0xc,%eax
  1040b9:	89 c1                	mov    %eax,%ecx
  1040bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040be:	c1 e0 0c             	shl    $0xc,%eax
  1040c1:	89 c2                	mov    %eax,%edx
  1040c3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  1040c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040c9:	29 c6                	sub    %eax,%esi
  1040cb:	89 f0                	mov    %esi,%eax
  1040cd:	83 ec 08             	sub    $0x8,%esp
  1040d0:	57                   	push   %edi
  1040d1:	53                   	push   %ebx
  1040d2:	51                   	push   %ecx
  1040d3:	52                   	push   %edx
  1040d4:	50                   	push   %eax
  1040d5:	68 d8 6b 10 00       	push   $0x106bd8
  1040da:	e8 88 c1 ff ff       	call   100267 <cprintf>
  1040df:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1040e2:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1040e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040ed:	89 d3                	mov    %edx,%ebx
  1040ef:	c1 e3 0a             	shl    $0xa,%ebx
  1040f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1040f5:	89 d1                	mov    %edx,%ecx
  1040f7:	c1 e1 0a             	shl    $0xa,%ecx
  1040fa:	83 ec 08             	sub    $0x8,%esp
  1040fd:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104100:	52                   	push   %edx
  104101:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104104:	52                   	push   %edx
  104105:	56                   	push   %esi
  104106:	50                   	push   %eax
  104107:	53                   	push   %ebx
  104108:	51                   	push   %ecx
  104109:	e8 52 fe ff ff       	call   103f60 <get_pgtable_items>
  10410e:	83 c4 20             	add    $0x20,%esp
  104111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104118:	0f 85 75 ff ff ff    	jne    104093 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10411e:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104123:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104126:	83 ec 08             	sub    $0x8,%esp
  104129:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10412c:	52                   	push   %edx
  10412d:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104130:	52                   	push   %edx
  104131:	51                   	push   %ecx
  104132:	50                   	push   %eax
  104133:	68 00 04 00 00       	push   $0x400
  104138:	6a 00                	push   $0x0
  10413a:	e8 21 fe ff ff       	call   103f60 <get_pgtable_items>
  10413f:	83 c4 20             	add    $0x20,%esp
  104142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104145:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104149:	0f 85 ea fe ff ff    	jne    104039 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10414f:	83 ec 0c             	sub    $0xc,%esp
  104152:	68 fc 6b 10 00       	push   $0x106bfc
  104157:	e8 0b c1 ff ff       	call   100267 <cprintf>
  10415c:	83 c4 10             	add    $0x10,%esp
}
  10415f:	90                   	nop
  104160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  104163:	5b                   	pop    %ebx
  104164:	5e                   	pop    %esi
  104165:	5f                   	pop    %edi
  104166:	5d                   	pop    %ebp
  104167:	c3                   	ret    

00104168 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104168:	55                   	push   %ebp
  104169:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10416b:	8b 45 08             	mov    0x8(%ebp),%eax
  10416e:	8b 15 58 89 11 00    	mov    0x118958,%edx
  104174:	29 d0                	sub    %edx,%eax
  104176:	c1 f8 02             	sar    $0x2,%eax
  104179:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10417f:	5d                   	pop    %ebp
  104180:	c3                   	ret    

00104181 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104181:	55                   	push   %ebp
  104182:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  104184:	ff 75 08             	pushl  0x8(%ebp)
  104187:	e8 dc ff ff ff       	call   104168 <page2ppn>
  10418c:	83 c4 04             	add    $0x4,%esp
  10418f:	c1 e0 0c             	shl    $0xc,%eax
}
  104192:	c9                   	leave  
  104193:	c3                   	ret    

00104194 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  104194:	55                   	push   %ebp
  104195:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104197:	8b 45 08             	mov    0x8(%ebp),%eax
  10419a:	8b 00                	mov    (%eax),%eax
}
  10419c:	5d                   	pop    %ebp
  10419d:	c3                   	ret    

0010419e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10419e:	55                   	push   %ebp
  10419f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1041a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1041a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041a7:	89 10                	mov    %edx,(%eax)
}
  1041a9:	90                   	nop
  1041aa:	5d                   	pop    %ebp
  1041ab:	c3                   	ret    

001041ac <display_free_list>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)
#define DEBUG 0 

static void display_free_list()
{
  1041ac:	55                   	push   %ebp
  1041ad:	89 e5                	mov    %esp,%ebp
  1041af:	83 ec 18             	sub    $0x18,%esp
    list_entry_t *le = &free_list;
  1041b2:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
        
    cprintf( "\n#################################\n" );
  1041b9:	83 ec 0c             	sub    $0xc,%esp
  1041bc:	68 30 6c 10 00       	push   $0x106c30
  1041c1:	e8 a1 c0 ff ff       	call   100267 <cprintf>
  1041c6:	83 c4 10             	add    $0x10,%esp
    while( &free_list != ( le = list_next( le ) ) )
  1041c9:	eb 31                	jmp    1041fc <display_free_list+0x50>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
  1041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041ce:	83 e8 0c             	sub    $0xc,%eax
  1041d1:	83 ec 08             	sub    $0x8,%esp
  1041d4:	50                   	push   %eax
  1041d5:	68 54 6c 10 00       	push   $0x106c54
  1041da:	e8 88 c0 ff ff       	call   100267 <cprintf>
  1041df:	83 c4 10             	add    $0x10,%esp
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
  1041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041e5:	83 e8 0c             	sub    $0xc,%eax
  1041e8:	8b 40 08             	mov    0x8(%eax),%eax
  1041eb:	83 ec 08             	sub    $0x8,%esp
  1041ee:	50                   	push   %eax
  1041ef:	68 6a 6c 10 00       	push   $0x106c6a
  1041f4:	e8 6e c0 ff ff       	call   100267 <cprintf>
  1041f9:	83 c4 10             	add    $0x10,%esp
  1041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104205:	8b 40 04             	mov    0x4(%eax),%eax
static void display_free_list()
{
    list_entry_t *le = &free_list;
        
    cprintf( "\n#################################\n" );
    while( &free_list != ( le = list_next( le ) ) )
  104208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10420b:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104212:	75 b7                	jne    1041cb <display_free_list+0x1f>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
    }
    cprintf( "#################################\n\n" );
  104214:	83 ec 0c             	sub    $0xc,%esp
  104217:	68 80 6c 10 00       	push   $0x106c80
  10421c:	e8 46 c0 ff ff       	call   100267 <cprintf>
  104221:	83 c4 10             	add    $0x10,%esp
}
  104224:	90                   	nop
  104225:	c9                   	leave  
  104226:	c3                   	ret    

00104227 <default_init>:

static void default_init( void ) 
{
  104227:	55                   	push   %ebp
  104228:	89 e5                	mov    %esp,%ebp
  10422a:	83 ec 10             	sub    $0x10,%esp
  10422d:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104234:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104237:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10423a:	89 50 04             	mov    %edx,0x4(%eax)
  10423d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104240:	8b 50 04             	mov    0x4(%eax),%edx
  104243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104246:	89 10                	mov    %edx,(%eax)
    list_init( &free_list );
    nr_free = 0;
  104248:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  10424f:	00 00 00 
}
  104252:	90                   	nop
  104253:	c9                   	leave  
  104254:	c3                   	ret    

00104255 <default_init_memmap>:

static void default_init_memmap( struct Page *base, size_t n ) 
{
  104255:	55                   	push   %ebp
  104256:	89 e5                	mov    %esp,%ebp
  104258:	83 ec 30             	sub    $0x30,%esp
    struct Page *p = base;
  10425b:	8b 45 08             	mov    0x8(%ebp),%eax
  10425e:	89 45 fc             	mov    %eax,-0x4(%ebp)

    for( ; p != base + n; p++ ) 
  104261:	eb 23                	jmp    104286 <default_init_memmap+0x31>
        p->flags = p->property = p->ref = 0;
  104263:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  10426c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10426f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104276:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104279:	8b 50 08             	mov    0x8(%eax),%edx
  10427c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10427f:	89 50 04             	mov    %edx,0x4(%eax)

static void default_init_memmap( struct Page *base, size_t n ) 
{
    struct Page *p = base;

    for( ; p != base + n; p++ ) 
  104282:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  104286:	8b 55 0c             	mov    0xc(%ebp),%edx
  104289:	89 d0                	mov    %edx,%eax
  10428b:	c1 e0 02             	shl    $0x2,%eax
  10428e:	01 d0                	add    %edx,%eax
  104290:	c1 e0 02             	shl    $0x2,%eax
  104293:	89 c2                	mov    %eax,%edx
  104295:	8b 45 08             	mov    0x8(%ebp),%eax
  104298:	01 d0                	add    %edx,%eax
  10429a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10429d:	75 c4                	jne    104263 <default_init_memmap+0xe>
        p->flags = p->property = p->ref = 0;
    
    SetPageProperty(base); 
  10429f:	8b 45 08             	mov    0x8(%ebp),%eax
  1042a2:	83 c0 04             	add    $0x4,%eax
  1042a5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
  1042ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1042af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1042b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1042b5:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  1042b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1042bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042be:	89 50 08             	mov    %edx,0x8(%eax)
    list_add( &free_list, &( base->page_link ) );
  1042c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1042c4:	83 c0 0c             	add    $0xc,%eax
  1042c7:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
  1042ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042da:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1042dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042e0:	8b 40 04             	mov    0x4(%eax),%eax
  1042e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1042e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1042e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1042ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1042f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1042f8:	89 10                	mov    %edx,(%eax)
  1042fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042fd:	8b 10                	mov    (%eax),%edx
  1042ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104302:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104308:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10430b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10430e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104311:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104314:	89 10                	mov    %edx,(%eax)
    nr_free += n;
  104316:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10431c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10431f:	01 d0                	add    %edx,%eax
  104321:	a3 64 89 11 00       	mov    %eax,0x118964
}
  104326:	90                   	nop
  104327:	c9                   	leave  
  104328:	c3                   	ret    

00104329 <default_alloc_pages>:

static struct Page *default_alloc_pages( size_t n ) 
{
  104329:	55                   	push   %ebp
  10432a:	89 e5                	mov    %esp,%ebp
  10432c:	83 ec 50             	sub    $0x50,%esp
    struct Page *page = NULL, *rp = NULL;
  10432f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  104336:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10433d:	c7 45 f8 5c 89 11 00 	movl   $0x11895c,-0x8(%ebp)
    int i;

    if( n > nr_free ) 
  104344:	a1 64 89 11 00       	mov    0x118964,%eax
  104349:	3b 45 08             	cmp    0x8(%ebp),%eax
  10434c:	0f 83 54 01 00 00    	jae    1044a6 <default_alloc_pages+0x17d>
        return NULL;
  104352:	b8 00 00 00 00       	mov    $0x0,%eax
  104357:	e9 69 01 00 00       	jmp    1044c5 <default_alloc_pages+0x19c>
    
    while( &free_list != ( le = list_next( le ) ) )  
    {
        struct Page *p = le2page(le, page_link), *pp;
  10435c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10435f:	83 e8 0c             	sub    $0xc,%eax
  104362:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        if( p->property >= n ) 
  104365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104368:	8b 40 08             	mov    0x8(%eax),%eax
  10436b:	3b 45 08             	cmp    0x8(%ebp),%eax
  10436e:	0f 82 32 01 00 00    	jb     1044a6 <default_alloc_pages+0x17d>
        {
            page = p;
  104374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104377:	89 45 fc             	mov    %eax,-0x4(%ebp)
            
            for( i = 0; i < n; i++ )
  10437a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104381:	eb 3e                	jmp    1043c1 <default_alloc_pages+0x98>
            {
                pp = page + i; 
  104383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104386:	89 d0                	mov    %edx,%eax
  104388:	c1 e0 02             	shl    $0x2,%eax
  10438b:	01 d0                	add    %edx,%eax
  10438d:	c1 e0 02             	shl    $0x2,%eax
  104390:	89 c2                	mov    %eax,%edx
  104392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104395:	01 d0                	add    %edx,%eax
  104397:	89 45 e8             	mov    %eax,-0x18(%ebp)
                pp->flags = 0;
  10439a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10439d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageReserved(pp);
  1043a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043a7:	83 c0 04             	add    $0x4,%eax
  1043aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  1043b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1043b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1043b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043ba:	0f ab 10             	bts    %edx,(%eax)
        
        if( p->property >= n ) 
        {
            page = p;
            
            for( i = 0; i < n; i++ )
  1043bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1043c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043c7:	72 ba                	jb     104383 <default_alloc_pages+0x5a>
                pp = page + i; 
                pp->flags = 0;
                SetPageReserved(pp);
            } 
            
            if( page->property > n)
  1043c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043cc:	8b 40 08             	mov    0x8(%eax),%eax
  1043cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043d2:	0f 86 8a 00 00 00    	jbe    104462 <default_alloc_pages+0x139>
            {
                ( page + n )->property = page->property - n;
  1043d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1043db:	89 d0                	mov    %edx,%eax
  1043dd:	c1 e0 02             	shl    $0x2,%eax
  1043e0:	01 d0                	add    %edx,%eax
  1043e2:	c1 e0 02             	shl    $0x2,%eax
  1043e5:	89 c2                	mov    %eax,%edx
  1043e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043ea:	01 c2                	add    %eax,%edx
  1043ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043ef:	8b 40 08             	mov    0x8(%eax),%eax
  1043f2:	2b 45 08             	sub    0x8(%ebp),%eax
  1043f5:	89 42 08             	mov    %eax,0x8(%edx)
                list_add( &( page->page_link ), &( ( page + n )->page_link ) );
  1043f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1043fb:	89 d0                	mov    %edx,%eax
  1043fd:	c1 e0 02             	shl    $0x2,%eax
  104400:	01 d0                	add    %edx,%eax
  104402:	c1 e0 02             	shl    $0x2,%eax
  104405:	89 c2                	mov    %eax,%edx
  104407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10440a:	01 d0                	add    %edx,%eax
  10440c:	83 c0 0c             	add    $0xc,%eax
  10440f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104412:	83 c2 0c             	add    $0xc,%edx
  104415:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  104418:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10441b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10441e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  104421:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104424:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104427:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10442a:	8b 40 04             	mov    0x4(%eax),%eax
  10442d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104430:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104433:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104436:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104439:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10443c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10443f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104442:	89 10                	mov    %edx,(%eax)
  104444:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104447:	8b 10                	mov    (%eax),%edx
  104449:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10444c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10444f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104452:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104455:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104458:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10445b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10445e:	89 10                	mov    %edx,(%eax)
  104460:	eb 0a                	jmp    10446c <default_alloc_pages+0x143>
                //rp = page + n;
            }
            else
            {
                page->property = 0;
  104462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104465:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                //rp = page;
            }

            list_del( &( page->page_link ) );
  10446c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10446f:	83 c0 0c             	add    $0xc,%eax
  104472:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104478:	8b 40 04             	mov    0x4(%eax),%eax
  10447b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10447e:	8b 12                	mov    (%edx),%edx
  104480:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104483:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104486:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104489:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10448c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10448f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104492:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104495:	89 10                	mov    %edx,(%eax)
            
            nr_free -= n;
  104497:	a1 64 89 11 00       	mov    0x118964,%eax
  10449c:	2b 45 08             	sub    0x8(%ebp),%eax
  10449f:	a3 64 89 11 00       	mov    %eax,0x118964
            break;
  1044a4:	eb 1c                	jmp    1044c2 <default_alloc_pages+0x199>
  1044a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1044a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1044ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044af:	8b 40 04             	mov    0x4(%eax),%eax
    int i;

    if( n > nr_free ) 
        return NULL;
    
    while( &free_list != ( le = list_next( le ) ) )  
  1044b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1044b5:	81 7d f8 5c 89 11 00 	cmpl   $0x11895c,-0x8(%ebp)
  1044bc:	0f 85 9a fe ff ff    	jne    10435c <default_alloc_pages+0x33>
            nr_free -= n;
            break;
        }
    }
    
    return page;
  1044c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1044c5:	c9                   	leave  
  1044c6:	c3                   	ret    

001044c7 <default_free_pages>:

static void default_free_pages( struct Page *base, size_t n ) 
{
  1044c7:	55                   	push   %ebp
  1044c8:	89 e5                	mov    %esp,%ebp
  1044ca:	81 ec d0 00 00 00    	sub    $0xd0,%esp
    struct Page *p = base, *page, *front_merge_p;
  1044d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    list_entry_t *le = &free_list; 
  1044d6:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
    size_t merge_front = 0, merge_back = 0;
  1044dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1044e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
  1044eb:	eb 1b                	jmp    104508 <default_free_pages+0x41>

#if DEBUG
        assert( !PageReserved(p) && !PageProperty(p) );
#endif
        
        p->flags = 0;
  1044ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref( p, 0 );
  1044f7:	6a 00                	push   $0x0
  1044f9:	ff 75 fc             	pushl  -0x4(%ebp)
  1044fc:	e8 9d fc ff ff       	call   10419e <set_page_ref>
  104501:	83 c4 08             	add    $0x8,%esp

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
  104504:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  104508:	8b 55 0c             	mov    0xc(%ebp),%edx
  10450b:	89 d0                	mov    %edx,%eax
  10450d:	c1 e0 02             	shl    $0x2,%eax
  104510:	01 d0                	add    %edx,%eax
  104512:	c1 e0 02             	shl    $0x2,%eax
  104515:	89 c2                	mov    %eax,%edx
  104517:	8b 45 08             	mov    0x8(%ebp),%eax
  10451a:	01 d0                	add    %edx,%eax
  10451c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10451f:	75 cc                	jne    1044ed <default_free_pages+0x26>
        
        p->flags = 0;
        set_page_ref( p, 0 );
    }
    
    SetPageProperty(base);
  104521:	8b 45 08             	mov    0x8(%ebp),%eax
  104524:	83 c0 04             	add    $0x4,%eax
  104527:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10452e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104531:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104537:	0f ab 10             	bts    %edx,(%eax)
    base->property = n; 
  10453a:	8b 45 08             	mov    0x8(%ebp),%eax
  10453d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104540:	89 50 08             	mov    %edx,0x8(%eax)
  104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104546:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104549:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10454c:	8b 40 04             	mov    0x4(%eax),%eax
    
    if( &free_list == list_next( le ) ) 
  10454f:	3d 5c 89 11 00       	cmp    $0x11895c,%eax
  104554:	0f 85 09 02 00 00    	jne    104763 <default_free_pages+0x29c>
    {
        base->flags = 0;
  10455a:	8b 45 08             	mov    0x8(%ebp),%eax
  10455d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(base); 
  104564:	8b 45 08             	mov    0x8(%ebp),%eax
  104567:	83 c0 04             	add    $0x4,%eax
  10456a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104571:	89 45 90             	mov    %eax,-0x70(%ebp)
  104574:	8b 45 90             	mov    -0x70(%ebp),%eax
  104577:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10457a:	0f ab 10             	bts    %edx,(%eax)
        list_add( &free_list, &( base->page_link ) );
  10457d:	8b 45 08             	mov    0x8(%ebp),%eax
  104580:	83 c0 0c             	add    $0xc,%eax
  104583:	c7 45 e4 5c 89 11 00 	movl   $0x11895c,-0x1c(%ebp)
  10458a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10458d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104590:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104593:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104596:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104599:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10459c:	8b 40 04             	mov    0x4(%eax),%eax
  10459f:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1045a2:	89 55 9c             	mov    %edx,-0x64(%ebp)
  1045a5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1045a8:	89 55 98             	mov    %edx,-0x68(%ebp)
  1045ab:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1045ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1045b1:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1045b4:	89 10                	mov    %edx,(%eax)
  1045b6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1045b9:	8b 10                	mov    (%eax),%edx
  1045bb:	8b 45 98             	mov    -0x68(%ebp),%eax
  1045be:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1045c1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1045c4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1045c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1045ca:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1045cd:	8b 55 98             	mov    -0x68(%ebp),%edx
  1045d0:	89 10                	mov    %edx,(%eax)
  1045d2:	e9 93 03 00 00       	jmp    10496a <default_free_pages+0x4a3>
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
        {
            page = le2page( le, page_link );
  1045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045da:	83 e8 0c             	sub    $0xc,%eax
  1045dd:	89 45 d0             	mov    %eax,-0x30(%ebp)

            if( base == page + page->property )
  1045e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045e3:	8b 50 08             	mov    0x8(%eax),%edx
  1045e6:	89 d0                	mov    %edx,%eax
  1045e8:	c1 e0 02             	shl    $0x2,%eax
  1045eb:	01 d0                	add    %edx,%eax
  1045ed:	c1 e0 02             	shl    $0x2,%eax
  1045f0:	89 c2                	mov    %eax,%edx
  1045f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045f5:	01 d0                	add    %edx,%eax
  1045f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  1045fa:	75 28                	jne    104624 <default_free_pages+0x15d>
            {
                front_merge_p = page;
  1045fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
                base->flags = 0;
  104602:	8b 45 08             	mov    0x8(%ebp),%eax
  104605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                page->property += n;
  10460c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10460f:	8b 50 08             	mov    0x8(%eax),%edx
  104612:	8b 45 0c             	mov    0xc(%ebp),%eax
  104615:	01 c2                	add    %eax,%edx
  104617:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10461a:	89 50 08             	mov    %edx,0x8(%eax)
                merge_front = 1;
  10461d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }

            if( page == base + base->property )
  104624:	8b 45 08             	mov    0x8(%ebp),%eax
  104627:	8b 50 08             	mov    0x8(%eax),%edx
  10462a:	89 d0                	mov    %edx,%eax
  10462c:	c1 e0 02             	shl    $0x2,%eax
  10462f:	01 d0                	add    %edx,%eax
  104631:	c1 e0 02             	shl    $0x2,%eax
  104634:	89 c2                	mov    %eax,%edx
  104636:	8b 45 08             	mov    0x8(%ebp),%eax
  104639:	01 d0                	add    %edx,%eax
  10463b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10463e:	0f 85 1f 01 00 00    	jne    104763 <default_free_pages+0x29c>
            {
                if( 1 == merge_front )
  104644:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  104648:	75 19                	jne    104663 <default_free_pages+0x19c>
                    front_merge_p->property += page->property; 
  10464a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10464d:	8b 50 08             	mov    0x8(%eax),%edx
  104650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104653:	8b 40 08             	mov    0x8(%eax),%eax
  104656:	01 c2                	add    %eax,%edx
  104658:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10465b:	89 50 08             	mov    %edx,0x8(%eax)
  10465e:	e9 a6 00 00 00       	jmp    104709 <default_free_pages+0x242>
                else
                {
                    base->flags = 0;
  104663:	8b 45 08             	mov    0x8(%ebp),%eax
  104666:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
  10466d:	8b 45 08             	mov    0x8(%ebp),%eax
  104670:	83 c0 04             	add    $0x4,%eax
  104673:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  10467a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  104680:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  104686:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104689:	0f ab 10             	bts    %edx,(%eax)
                    base->property = n + page->property;
  10468c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10468f:	8b 50 08             	mov    0x8(%eax),%edx
  104692:	8b 45 0c             	mov    0xc(%ebp),%eax
  104695:	01 c2                	add    %eax,%edx
  104697:	8b 45 08             	mov    0x8(%ebp),%eax
  10469a:	89 50 08             	mov    %edx,0x8(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) );
  10469d:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a0:	8d 50 0c             	lea    0xc(%eax),%edx
  1046a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046a6:	8b 40 0c             	mov    0xc(%eax),%eax
  1046a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046ac:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1046af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046b2:	89 45 88             	mov    %eax,-0x78(%ebp)
  1046b5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1046b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1046bb:	8b 45 88             	mov    -0x78(%ebp),%eax
  1046be:	8b 40 04             	mov    0x4(%eax),%eax
  1046c1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1046c4:	89 55 80             	mov    %edx,-0x80(%ebp)
  1046c7:	8b 55 88             	mov    -0x78(%ebp),%edx
  1046ca:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  1046d0:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1046d6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1046dc:	8b 55 80             	mov    -0x80(%ebp),%edx
  1046df:	89 10                	mov    %edx,(%eax)
  1046e1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1046e7:	8b 10                	mov    (%eax),%edx
  1046e9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1046ef:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1046f2:	8b 45 80             	mov    -0x80(%ebp),%eax
  1046f5:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  1046fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1046fe:	8b 45 80             	mov    -0x80(%ebp),%eax
  104701:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104707:	89 10                	mov    %edx,(%eax)
                }

                page->flags = page->property = 0;
  104709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10470c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104713:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104716:	8b 50 08             	mov    0x8(%eax),%edx
  104719:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10471c:	89 50 04             	mov    %edx,0x4(%eax)
                list_del( &( page->page_link ) );
  10471f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104722:	83 c0 0c             	add    $0xc,%eax
  104725:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104728:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10472b:	8b 40 04             	mov    0x4(%eax),%eax
  10472e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104731:	8b 12                	mov    (%edx),%edx
  104733:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  104739:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10473f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  104745:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  10474b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10474e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  104754:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  10475a:	89 10                	mov    %edx,(%eax)
                merge_back = 1;
  10475c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104766:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104769:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10476c:	8b 40 04             	mov    0x4(%eax),%eax
        SetPageProperty(base); 
        list_add( &free_list, &( base->page_link ) );
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
  10476f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104772:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104779:	0f 85 58 fe ff ff    	jne    1045d7 <default_free_pages+0x110>
                list_del( &( page->page_link ) );
                merge_back = 1;
            }
        }
        
        if( 1 == merge_front )
  10477f:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  104783:	75 0f                	jne    104794 <default_free_pages+0x2cd>
            base->property = 0;
  104785:	8b 45 08             	mov    0x8(%ebp),%eax
  104788:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10478f:	e9 d6 01 00 00       	jmp    10496a <default_free_pages+0x4a3>
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
  104794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104798:	0f 85 cc 01 00 00    	jne    10496a <default_free_pages+0x4a3>
  10479e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1047a2:	0f 85 c2 01 00 00    	jne    10496a <default_free_pages+0x4a3>
        {
            size_t found = 0;
  1047a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

            le = &free_list; 
  1047af:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
            while( &free_list != ( le = ( list_next( le ) ) ) )
  1047b6:	e9 d4 00 00 00       	jmp    10488f <default_free_pages+0x3c8>
            {
                page = le2page( le, page_link );
  1047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047be:	83 e8 0c             	sub    $0xc,%eax
  1047c1:	89 45 d0             	mov    %eax,-0x30(%ebp)

                if( page > base )
  1047c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1047c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  1047ca:	0f 86 bf 00 00 00    	jbe    10488f <default_free_pages+0x3c8>
                {
                    base->flags = 0;
  1047d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
  1047da:	8b 45 08             	mov    0x8(%ebp),%eax
  1047dd:	83 c0 04             	add    $0x4,%eax
  1047e0:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1047e7:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  1047ed:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  1047f3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1047f6:	0f ab 10             	bts    %edx,(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) ); 
  1047f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1047fc:	8d 50 0c             	lea    0xc(%eax),%edx
  1047ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104802:	8b 40 0c             	mov    0xc(%eax),%eax
  104805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104808:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
  10480e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104811:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  104817:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  10481d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104823:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  104829:	8b 40 04             	mov    0x4(%eax),%eax
  10482c:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  104832:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  104838:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  10483e:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
  104844:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10484a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  104850:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  104856:	89 10                	mov    %edx,(%eax)
  104858:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  10485e:	8b 10                	mov    (%eax),%edx
  104860:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  104866:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104869:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  10486f:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  104875:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104878:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  10487e:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  104884:	89 10                	mov    %edx,(%eax)
                    found = 1;
  104886:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
                    break;
  10488d:	eb 1c                	jmp    1048ab <default_free_pages+0x3e4>
  10488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104892:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104895:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104898:	8b 40 04             	mov    0x4(%eax),%eax
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
        {
            size_t found = 0;

            le = &free_list; 
            while( &free_list != ( le = ( list_next( le ) ) ) )
  10489b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10489e:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  1048a5:	0f 85 10 ff ff ff    	jne    1047bb <default_free_pages+0x2f4>
                    found = 1;
                    break;
                }
            }

            if( 0 == found )
  1048ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1048af:	0f 85 b5 00 00 00    	jne    10496a <default_free_pages+0x4a3>
            {
                base->flags = 0;
  1048b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageProperty(base); 
  1048bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c2:	83 c0 04             	add    $0x4,%eax
  1048c5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  1048cc:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  1048d2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  1048d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1048db:	0f ab 10             	bts    %edx,(%eax)
                list_add( free_list.prev, &( base->page_link ) ); 
  1048de:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e1:	8d 50 0c             	lea    0xc(%eax),%edx
  1048e4:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1048e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1048ec:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
  1048f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1048f5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  1048fb:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  104901:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104907:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  10490d:	8b 40 04             	mov    0x4(%eax),%eax
  104910:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  104916:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  10491c:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  104922:	89 95 3c ff ff ff    	mov    %edx,-0xc4(%ebp)
  104928:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10492e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  104934:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  10493a:	89 10                	mov    %edx,(%eax)
  10493c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  104942:	8b 10                	mov    (%eax),%edx
  104944:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  10494a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10494d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  104953:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  104959:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10495c:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  104962:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  104968:	89 10                	mov    %edx,(%eax)
            }
        }
    }

    nr_free += n;
  10496a:	8b 15 64 89 11 00    	mov    0x118964,%edx
  104970:	8b 45 0c             	mov    0xc(%ebp),%eax
  104973:	01 d0                	add    %edx,%eax
  104975:	a3 64 89 11 00       	mov    %eax,0x118964
}
  10497a:	90                   	nop
  10497b:	c9                   	leave  
  10497c:	c3                   	ret    

0010497d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10497d:	55                   	push   %ebp
  10497e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104980:	a1 64 89 11 00       	mov    0x118964,%eax
}
  104985:	5d                   	pop    %ebp
  104986:	c3                   	ret    

00104987 <basic_check>:

static void
basic_check(void) {
  104987:	55                   	push   %ebp
  104988:	89 e5                	mov    %esp,%ebp
  10498a:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10498d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10499a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10499d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1049a0:	83 ec 0c             	sub    $0xc,%esp
  1049a3:	6a 01                	push   $0x1
  1049a5:	e8 c6 e1 ff ff       	call   102b70 <alloc_pages>
  1049aa:	83 c4 10             	add    $0x10,%esp
  1049ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1049b4:	75 19                	jne    1049cf <basic_check+0x48>
  1049b6:	68 a4 6c 10 00       	push   $0x106ca4
  1049bb:	68 c0 6c 10 00       	push   $0x106cc0
  1049c0:	68 f5 00 00 00       	push   $0xf5
  1049c5:	68 d5 6c 10 00       	push   $0x106cd5
  1049ca:	e8 fe b9 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  1049cf:	83 ec 0c             	sub    $0xc,%esp
  1049d2:	6a 01                	push   $0x1
  1049d4:	e8 97 e1 ff ff       	call   102b70 <alloc_pages>
  1049d9:	83 c4 10             	add    $0x10,%esp
  1049dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049e3:	75 19                	jne    1049fe <basic_check+0x77>
  1049e5:	68 eb 6c 10 00       	push   $0x106ceb
  1049ea:	68 c0 6c 10 00       	push   $0x106cc0
  1049ef:	68 f6 00 00 00       	push   $0xf6
  1049f4:	68 d5 6c 10 00       	push   $0x106cd5
  1049f9:	e8 cf b9 ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  1049fe:	83 ec 0c             	sub    $0xc,%esp
  104a01:	6a 01                	push   $0x1
  104a03:	e8 68 e1 ff ff       	call   102b70 <alloc_pages>
  104a08:	83 c4 10             	add    $0x10,%esp
  104a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a12:	75 19                	jne    104a2d <basic_check+0xa6>
  104a14:	68 07 6d 10 00       	push   $0x106d07
  104a19:	68 c0 6c 10 00       	push   $0x106cc0
  104a1e:	68 f7 00 00 00       	push   $0xf7
  104a23:	68 d5 6c 10 00       	push   $0x106cd5
  104a28:	e8 a0 b9 ff ff       	call   1003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a33:	74 10                	je     104a45 <basic_check+0xbe>
  104a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a3b:	74 08                	je     104a45 <basic_check+0xbe>
  104a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a43:	75 19                	jne    104a5e <basic_check+0xd7>
  104a45:	68 24 6d 10 00       	push   $0x106d24
  104a4a:	68 c0 6c 10 00       	push   $0x106cc0
  104a4f:	68 f9 00 00 00       	push   $0xf9
  104a54:	68 d5 6c 10 00       	push   $0x106cd5
  104a59:	e8 6f b9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104a5e:	83 ec 0c             	sub    $0xc,%esp
  104a61:	ff 75 ec             	pushl  -0x14(%ebp)
  104a64:	e8 2b f7 ff ff       	call   104194 <page_ref>
  104a69:	83 c4 10             	add    $0x10,%esp
  104a6c:	85 c0                	test   %eax,%eax
  104a6e:	75 24                	jne    104a94 <basic_check+0x10d>
  104a70:	83 ec 0c             	sub    $0xc,%esp
  104a73:	ff 75 f0             	pushl  -0x10(%ebp)
  104a76:	e8 19 f7 ff ff       	call   104194 <page_ref>
  104a7b:	83 c4 10             	add    $0x10,%esp
  104a7e:	85 c0                	test   %eax,%eax
  104a80:	75 12                	jne    104a94 <basic_check+0x10d>
  104a82:	83 ec 0c             	sub    $0xc,%esp
  104a85:	ff 75 f4             	pushl  -0xc(%ebp)
  104a88:	e8 07 f7 ff ff       	call   104194 <page_ref>
  104a8d:	83 c4 10             	add    $0x10,%esp
  104a90:	85 c0                	test   %eax,%eax
  104a92:	74 19                	je     104aad <basic_check+0x126>
  104a94:	68 48 6d 10 00       	push   $0x106d48
  104a99:	68 c0 6c 10 00       	push   $0x106cc0
  104a9e:	68 fa 00 00 00       	push   $0xfa
  104aa3:	68 d5 6c 10 00       	push   $0x106cd5
  104aa8:	e8 20 b9 ff ff       	call   1003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104aad:	83 ec 0c             	sub    $0xc,%esp
  104ab0:	ff 75 ec             	pushl  -0x14(%ebp)
  104ab3:	e8 c9 f6 ff ff       	call   104181 <page2pa>
  104ab8:	83 c4 10             	add    $0x10,%esp
  104abb:	89 c2                	mov    %eax,%edx
  104abd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104ac2:	c1 e0 0c             	shl    $0xc,%eax
  104ac5:	39 c2                	cmp    %eax,%edx
  104ac7:	72 19                	jb     104ae2 <basic_check+0x15b>
  104ac9:	68 84 6d 10 00       	push   $0x106d84
  104ace:	68 c0 6c 10 00       	push   $0x106cc0
  104ad3:	68 fc 00 00 00       	push   $0xfc
  104ad8:	68 d5 6c 10 00       	push   $0x106cd5
  104add:	e8 eb b8 ff ff       	call   1003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104ae2:	83 ec 0c             	sub    $0xc,%esp
  104ae5:	ff 75 f0             	pushl  -0x10(%ebp)
  104ae8:	e8 94 f6 ff ff       	call   104181 <page2pa>
  104aed:	83 c4 10             	add    $0x10,%esp
  104af0:	89 c2                	mov    %eax,%edx
  104af2:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104af7:	c1 e0 0c             	shl    $0xc,%eax
  104afa:	39 c2                	cmp    %eax,%edx
  104afc:	72 19                	jb     104b17 <basic_check+0x190>
  104afe:	68 a1 6d 10 00       	push   $0x106da1
  104b03:	68 c0 6c 10 00       	push   $0x106cc0
  104b08:	68 fd 00 00 00       	push   $0xfd
  104b0d:	68 d5 6c 10 00       	push   $0x106cd5
  104b12:	e8 b6 b8 ff ff       	call   1003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104b17:	83 ec 0c             	sub    $0xc,%esp
  104b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  104b1d:	e8 5f f6 ff ff       	call   104181 <page2pa>
  104b22:	83 c4 10             	add    $0x10,%esp
  104b25:	89 c2                	mov    %eax,%edx
  104b27:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104b2c:	c1 e0 0c             	shl    $0xc,%eax
  104b2f:	39 c2                	cmp    %eax,%edx
  104b31:	72 19                	jb     104b4c <basic_check+0x1c5>
  104b33:	68 be 6d 10 00       	push   $0x106dbe
  104b38:	68 c0 6c 10 00       	push   $0x106cc0
  104b3d:	68 fe 00 00 00       	push   $0xfe
  104b42:	68 d5 6c 10 00       	push   $0x106cd5
  104b47:	e8 81 b8 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104b4c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104b51:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104b57:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104b5a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104b5d:	c7 45 e4 5c 89 11 00 	movl   $0x11895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104b6a:	89 50 04             	mov    %edx,0x4(%eax)
  104b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b70:	8b 50 04             	mov    0x4(%eax),%edx
  104b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b76:	89 10                	mov    %edx,(%eax)
  104b78:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104b82:	8b 40 04             	mov    0x4(%eax),%eax
  104b85:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104b88:	0f 94 c0             	sete   %al
  104b8b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104b8e:	85 c0                	test   %eax,%eax
  104b90:	75 19                	jne    104bab <basic_check+0x224>
  104b92:	68 db 6d 10 00       	push   $0x106ddb
  104b97:	68 c0 6c 10 00       	push   $0x106cc0
  104b9c:	68 02 01 00 00       	push   $0x102
  104ba1:	68 d5 6c 10 00       	push   $0x106cd5
  104ba6:	e8 22 b8 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  104bab:	a1 64 89 11 00       	mov    0x118964,%eax
  104bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104bb3:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104bba:	00 00 00 
    assert(alloc_page() == NULL);
  104bbd:	83 ec 0c             	sub    $0xc,%esp
  104bc0:	6a 01                	push   $0x1
  104bc2:	e8 a9 df ff ff       	call   102b70 <alloc_pages>
  104bc7:	83 c4 10             	add    $0x10,%esp
  104bca:	85 c0                	test   %eax,%eax
  104bcc:	74 19                	je     104be7 <basic_check+0x260>
  104bce:	68 f2 6d 10 00       	push   $0x106df2
  104bd3:	68 c0 6c 10 00       	push   $0x106cc0
  104bd8:	68 06 01 00 00       	push   $0x106
  104bdd:	68 d5 6c 10 00       	push   $0x106cd5
  104be2:	e8 e6 b7 ff ff       	call   1003cd <__panic>
    
    free_page(p0);
  104be7:	83 ec 08             	sub    $0x8,%esp
  104bea:	6a 01                	push   $0x1
  104bec:	ff 75 ec             	pushl  -0x14(%ebp)
  104bef:	e8 ba df ff ff       	call   102bae <free_pages>
  104bf4:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104bf7:	83 ec 08             	sub    $0x8,%esp
  104bfa:	6a 01                	push   $0x1
  104bfc:	ff 75 f0             	pushl  -0x10(%ebp)
  104bff:	e8 aa df ff ff       	call   102bae <free_pages>
  104c04:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104c07:	83 ec 08             	sub    $0x8,%esp
  104c0a:	6a 01                	push   $0x1
  104c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  104c0f:	e8 9a df ff ff       	call   102bae <free_pages>
  104c14:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  104c17:	a1 64 89 11 00       	mov    0x118964,%eax
  104c1c:	83 f8 03             	cmp    $0x3,%eax
  104c1f:	74 19                	je     104c3a <basic_check+0x2b3>
  104c21:	68 07 6e 10 00       	push   $0x106e07
  104c26:	68 c0 6c 10 00       	push   $0x106cc0
  104c2b:	68 0b 01 00 00       	push   $0x10b
  104c30:	68 d5 6c 10 00       	push   $0x106cd5
  104c35:	e8 93 b7 ff ff       	call   1003cd <__panic>
    
    assert((p0 = alloc_page()) != NULL);
  104c3a:	83 ec 0c             	sub    $0xc,%esp
  104c3d:	6a 01                	push   $0x1
  104c3f:	e8 2c df ff ff       	call   102b70 <alloc_pages>
  104c44:	83 c4 10             	add    $0x10,%esp
  104c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104c4e:	75 19                	jne    104c69 <basic_check+0x2e2>
  104c50:	68 a4 6c 10 00       	push   $0x106ca4
  104c55:	68 c0 6c 10 00       	push   $0x106cc0
  104c5a:	68 0d 01 00 00       	push   $0x10d
  104c5f:	68 d5 6c 10 00       	push   $0x106cd5
  104c64:	e8 64 b7 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104c69:	83 ec 0c             	sub    $0xc,%esp
  104c6c:	6a 01                	push   $0x1
  104c6e:	e8 fd de ff ff       	call   102b70 <alloc_pages>
  104c73:	83 c4 10             	add    $0x10,%esp
  104c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c7d:	75 19                	jne    104c98 <basic_check+0x311>
  104c7f:	68 eb 6c 10 00       	push   $0x106ceb
  104c84:	68 c0 6c 10 00       	push   $0x106cc0
  104c89:	68 0e 01 00 00       	push   $0x10e
  104c8e:	68 d5 6c 10 00       	push   $0x106cd5
  104c93:	e8 35 b7 ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104c98:	83 ec 0c             	sub    $0xc,%esp
  104c9b:	6a 01                	push   $0x1
  104c9d:	e8 ce de ff ff       	call   102b70 <alloc_pages>
  104ca2:	83 c4 10             	add    $0x10,%esp
  104ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104cac:	75 19                	jne    104cc7 <basic_check+0x340>
  104cae:	68 07 6d 10 00       	push   $0x106d07
  104cb3:	68 c0 6c 10 00       	push   $0x106cc0
  104cb8:	68 0f 01 00 00       	push   $0x10f
  104cbd:	68 d5 6c 10 00       	push   $0x106cd5
  104cc2:	e8 06 b7 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104cc7:	83 ec 0c             	sub    $0xc,%esp
  104cca:	6a 01                	push   $0x1
  104ccc:	e8 9f de ff ff       	call   102b70 <alloc_pages>
  104cd1:	83 c4 10             	add    $0x10,%esp
  104cd4:	85 c0                	test   %eax,%eax
  104cd6:	74 19                	je     104cf1 <basic_check+0x36a>
  104cd8:	68 f2 6d 10 00       	push   $0x106df2
  104cdd:	68 c0 6c 10 00       	push   $0x106cc0
  104ce2:	68 10 01 00 00       	push   $0x110
  104ce7:	68 d5 6c 10 00       	push   $0x106cd5
  104cec:	e8 dc b6 ff ff       	call   1003cd <__panic>
    free_page(p0);
  104cf1:	83 ec 08             	sub    $0x8,%esp
  104cf4:	6a 01                	push   $0x1
  104cf6:	ff 75 ec             	pushl  -0x14(%ebp)
  104cf9:	e8 b0 de ff ff       	call   102bae <free_pages>
  104cfe:	83 c4 10             	add    $0x10,%esp
  104d01:	c7 45 e8 5c 89 11 00 	movl   $0x11895c,-0x18(%ebp)
  104d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d0b:	8b 40 04             	mov    0x4(%eax),%eax
  104d0e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104d11:	0f 94 c0             	sete   %al
  104d14:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104d17:	85 c0                	test   %eax,%eax
  104d19:	74 19                	je     104d34 <basic_check+0x3ad>
  104d1b:	68 14 6e 10 00       	push   $0x106e14
  104d20:	68 c0 6c 10 00       	push   $0x106cc0
  104d25:	68 12 01 00 00       	push   $0x112
  104d2a:	68 d5 6c 10 00       	push   $0x106cd5
  104d2f:	e8 99 b6 ff ff       	call   1003cd <__panic>
    
    struct Page *p;
    assert((p = alloc_page()) == p0);
  104d34:	83 ec 0c             	sub    $0xc,%esp
  104d37:	6a 01                	push   $0x1
  104d39:	e8 32 de ff ff       	call   102b70 <alloc_pages>
  104d3e:	83 c4 10             	add    $0x10,%esp
  104d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104d4a:	74 19                	je     104d65 <basic_check+0x3de>
  104d4c:	68 2c 6e 10 00       	push   $0x106e2c
  104d51:	68 c0 6c 10 00       	push   $0x106cc0
  104d56:	68 15 01 00 00       	push   $0x115
  104d5b:	68 d5 6c 10 00       	push   $0x106cd5
  104d60:	e8 68 b6 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104d65:	83 ec 0c             	sub    $0xc,%esp
  104d68:	6a 01                	push   $0x1
  104d6a:	e8 01 de ff ff       	call   102b70 <alloc_pages>
  104d6f:	83 c4 10             	add    $0x10,%esp
  104d72:	85 c0                	test   %eax,%eax
  104d74:	74 19                	je     104d8f <basic_check+0x408>
  104d76:	68 f2 6d 10 00       	push   $0x106df2
  104d7b:	68 c0 6c 10 00       	push   $0x106cc0
  104d80:	68 16 01 00 00       	push   $0x116
  104d85:	68 d5 6c 10 00       	push   $0x106cd5
  104d8a:	e8 3e b6 ff ff       	call   1003cd <__panic>
    assert(nr_free == 0);
  104d8f:	a1 64 89 11 00       	mov    0x118964,%eax
  104d94:	85 c0                	test   %eax,%eax
  104d96:	74 19                	je     104db1 <basic_check+0x42a>
  104d98:	68 45 6e 10 00       	push   $0x106e45
  104d9d:	68 c0 6c 10 00       	push   $0x106cc0
  104da2:	68 17 01 00 00       	push   $0x117
  104da7:	68 d5 6c 10 00       	push   $0x106cd5
  104dac:	e8 1c b6 ff ff       	call   1003cd <__panic>
    free_list = free_list_store;
  104db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104db4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104db7:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104dbc:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  104dc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104dc5:	a3 64 89 11 00       	mov    %eax,0x118964
    free_page(p);
  104dca:	83 ec 08             	sub    $0x8,%esp
  104dcd:	6a 01                	push   $0x1
  104dcf:	ff 75 dc             	pushl  -0x24(%ebp)
  104dd2:	e8 d7 dd ff ff       	call   102bae <free_pages>
  104dd7:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104dda:	83 ec 08             	sub    $0x8,%esp
  104ddd:	6a 01                	push   $0x1
  104ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  104de2:	e8 c7 dd ff ff       	call   102bae <free_pages>
  104de7:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104dea:	83 ec 08             	sub    $0x8,%esp
  104ded:	6a 01                	push   $0x1
  104def:	ff 75 f4             	pushl  -0xc(%ebp)
  104df2:	e8 b7 dd ff ff       	call   102bae <free_pages>
  104df7:	83 c4 10             	add    $0x10,%esp
}
  104dfa:	90                   	nop
  104dfb:	c9                   	leave  
  104dfc:	c3                   	ret    

00104dfd <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104dfd:	55                   	push   %ebp
  104dfe:	89 e5                	mov    %esp,%ebp
  104e00:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104e06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104e14:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104e1b:	eb 60                	jmp    104e7d <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e20:	83 e8 0c             	sub    $0xc,%eax
  104e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e29:	83 c0 04             	add    $0x4,%eax
  104e2c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104e33:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e36:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104e39:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104e3c:	0f a3 10             	bt     %edx,(%eax)
  104e3f:	19 c0                	sbb    %eax,%eax
  104e41:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104e44:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104e48:	0f 95 c0             	setne  %al
  104e4b:	0f b6 c0             	movzbl %al,%eax
  104e4e:	85 c0                	test   %eax,%eax
  104e50:	75 19                	jne    104e6b <default_check+0x6e>
  104e52:	68 52 6e 10 00       	push   $0x106e52
  104e57:	68 c0 6c 10 00       	push   $0x106cc0
  104e5c:	68 27 01 00 00       	push   $0x127
  104e61:	68 d5 6c 10 00       	push   $0x106cd5
  104e66:	e8 62 b5 ff ff       	call   1003cd <__panic>
        count++, total += p->property;
  104e6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e72:	8b 50 08             	mov    0x8(%eax),%edx
  104e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e78:	01 d0                	add    %edx,%eax
  104e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e86:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104e89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e8c:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104e93:	75 88                	jne    104e1d <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count++, total += p->property;
    }
    assert(total == nr_free_pages());
  104e95:	e8 49 dd ff ff       	call   102be3 <nr_free_pages>
  104e9a:	89 c2                	mov    %eax,%edx
  104e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e9f:	39 c2                	cmp    %eax,%edx
  104ea1:	74 19                	je     104ebc <default_check+0xbf>
  104ea3:	68 62 6e 10 00       	push   $0x106e62
  104ea8:	68 c0 6c 10 00       	push   $0x106cc0
  104ead:	68 2a 01 00 00       	push   $0x12a
  104eb2:	68 d5 6c 10 00       	push   $0x106cd5
  104eb7:	e8 11 b5 ff ff       	call   1003cd <__panic>

    basic_check();
  104ebc:	e8 c6 fa ff ff       	call   104987 <basic_check>
    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104ec1:	83 ec 0c             	sub    $0xc,%esp
  104ec4:	6a 05                	push   $0x5
  104ec6:	e8 a5 dc ff ff       	call   102b70 <alloc_pages>
  104ecb:	83 c4 10             	add    $0x10,%esp
  104ece:	89 45 dc             	mov    %eax,-0x24(%ebp)
    
    assert(p0 != NULL);
  104ed1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104ed5:	75 19                	jne    104ef0 <default_check+0xf3>
  104ed7:	68 7b 6e 10 00       	push   $0x106e7b
  104edc:	68 c0 6c 10 00       	push   $0x106cc0
  104ee1:	68 2f 01 00 00       	push   $0x12f
  104ee6:	68 d5 6c 10 00       	push   $0x106cd5
  104eeb:	e8 dd b4 ff ff       	call   1003cd <__panic>
    assert(!PageProperty(p0));
  104ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ef3:	83 c0 04             	add    $0x4,%eax
  104ef6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104efd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f00:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104f03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104f06:	0f a3 10             	bt     %edx,(%eax)
  104f09:	19 c0                	sbb    %eax,%eax
  104f0b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104f0e:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104f12:	0f 95 c0             	setne  %al
  104f15:	0f b6 c0             	movzbl %al,%eax
  104f18:	85 c0                	test   %eax,%eax
  104f1a:	74 19                	je     104f35 <default_check+0x138>
  104f1c:	68 86 6e 10 00       	push   $0x106e86
  104f21:	68 c0 6c 10 00       	push   $0x106cc0
  104f26:	68 30 01 00 00       	push   $0x130
  104f2b:	68 d5 6c 10 00       	push   $0x106cd5
  104f30:	e8 98 b4 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104f35:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104f3a:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104f40:	89 45 80             	mov    %eax,-0x80(%ebp)
  104f43:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104f46:	c7 45 d0 5c 89 11 00 	movl   $0x11895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f50:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f53:	89 50 04             	mov    %edx,0x4(%eax)
  104f56:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f59:	8b 50 04             	mov    0x4(%eax),%edx
  104f5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f5f:	89 10                	mov    %edx,(%eax)
  104f61:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104f6b:	8b 40 04             	mov    0x4(%eax),%eax
  104f6e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104f71:	0f 94 c0             	sete   %al
  104f74:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104f77:	85 c0                	test   %eax,%eax
  104f79:	75 19                	jne    104f94 <default_check+0x197>
  104f7b:	68 db 6d 10 00       	push   $0x106ddb
  104f80:	68 c0 6c 10 00       	push   $0x106cc0
  104f85:	68 34 01 00 00       	push   $0x134
  104f8a:	68 d5 6c 10 00       	push   $0x106cd5
  104f8f:	e8 39 b4 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104f94:	83 ec 0c             	sub    $0xc,%esp
  104f97:	6a 01                	push   $0x1
  104f99:	e8 d2 db ff ff       	call   102b70 <alloc_pages>
  104f9e:	83 c4 10             	add    $0x10,%esp
  104fa1:	85 c0                	test   %eax,%eax
  104fa3:	74 19                	je     104fbe <default_check+0x1c1>
  104fa5:	68 f2 6d 10 00       	push   $0x106df2
  104faa:	68 c0 6c 10 00       	push   $0x106cc0
  104faf:	68 35 01 00 00       	push   $0x135
  104fb4:	68 d5 6c 10 00       	push   $0x106cd5
  104fb9:	e8 0f b4 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  104fbe:	a1 64 89 11 00       	mov    0x118964,%eax
  104fc3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104fc6:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104fcd:	00 00 00 

    free_pages(p0 + 2, 3);
  104fd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104fd3:	83 c0 28             	add    $0x28,%eax
  104fd6:	83 ec 08             	sub    $0x8,%esp
  104fd9:	6a 03                	push   $0x3
  104fdb:	50                   	push   %eax
  104fdc:	e8 cd db ff ff       	call   102bae <free_pages>
  104fe1:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104fe4:	83 ec 0c             	sub    $0xc,%esp
  104fe7:	6a 04                	push   $0x4
  104fe9:	e8 82 db ff ff       	call   102b70 <alloc_pages>
  104fee:	83 c4 10             	add    $0x10,%esp
  104ff1:	85 c0                	test   %eax,%eax
  104ff3:	74 19                	je     10500e <default_check+0x211>
  104ff5:	68 98 6e 10 00       	push   $0x106e98
  104ffa:	68 c0 6c 10 00       	push   $0x106cc0
  104fff:	68 3b 01 00 00       	push   $0x13b
  105004:	68 d5 6c 10 00       	push   $0x106cd5
  105009:	e8 bf b3 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10500e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105011:	83 c0 28             	add    $0x28,%eax
  105014:	83 c0 04             	add    $0x4,%eax
  105017:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10501e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105021:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105027:	0f a3 10             	bt     %edx,(%eax)
  10502a:	19 c0                	sbb    %eax,%eax
  10502c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10502f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105033:	0f 95 c0             	setne  %al
  105036:	0f b6 c0             	movzbl %al,%eax
  105039:	85 c0                	test   %eax,%eax
  10503b:	74 0e                	je     10504b <default_check+0x24e>
  10503d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105040:	83 c0 28             	add    $0x28,%eax
  105043:	8b 40 08             	mov    0x8(%eax),%eax
  105046:	83 f8 03             	cmp    $0x3,%eax
  105049:	74 19                	je     105064 <default_check+0x267>
  10504b:	68 b0 6e 10 00       	push   $0x106eb0
  105050:	68 c0 6c 10 00       	push   $0x106cc0
  105055:	68 3c 01 00 00       	push   $0x13c
  10505a:	68 d5 6c 10 00       	push   $0x106cd5
  10505f:	e8 69 b3 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105064:	83 ec 0c             	sub    $0xc,%esp
  105067:	6a 03                	push   $0x3
  105069:	e8 02 db ff ff       	call   102b70 <alloc_pages>
  10506e:	83 c4 10             	add    $0x10,%esp
  105071:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  105074:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  105078:	75 19                	jne    105093 <default_check+0x296>
  10507a:	68 dc 6e 10 00       	push   $0x106edc
  10507f:	68 c0 6c 10 00       	push   $0x106cc0
  105084:	68 3d 01 00 00       	push   $0x13d
  105089:	68 d5 6c 10 00       	push   $0x106cd5
  10508e:	e8 3a b3 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  105093:	83 ec 0c             	sub    $0xc,%esp
  105096:	6a 01                	push   $0x1
  105098:	e8 d3 da ff ff       	call   102b70 <alloc_pages>
  10509d:	83 c4 10             	add    $0x10,%esp
  1050a0:	85 c0                	test   %eax,%eax
  1050a2:	74 19                	je     1050bd <default_check+0x2c0>
  1050a4:	68 f2 6d 10 00       	push   $0x106df2
  1050a9:	68 c0 6c 10 00       	push   $0x106cc0
  1050ae:	68 3e 01 00 00       	push   $0x13e
  1050b3:	68 d5 6c 10 00       	push   $0x106cd5
  1050b8:	e8 10 b3 ff ff       	call   1003cd <__panic>
    assert(p0 + 2 == p1);
  1050bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050c0:	83 c0 28             	add    $0x28,%eax
  1050c3:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  1050c6:	74 19                	je     1050e1 <default_check+0x2e4>
  1050c8:	68 fa 6e 10 00       	push   $0x106efa
  1050cd:	68 c0 6c 10 00       	push   $0x106cc0
  1050d2:	68 3f 01 00 00       	push   $0x13f
  1050d7:	68 d5 6c 10 00       	push   $0x106cd5
  1050dc:	e8 ec b2 ff ff       	call   1003cd <__panic>

    p2 = p0 + 1;
  1050e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050e4:	83 c0 14             	add    $0x14,%eax
  1050e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  1050ea:	83 ec 08             	sub    $0x8,%esp
  1050ed:	6a 01                	push   $0x1
  1050ef:	ff 75 dc             	pushl  -0x24(%ebp)
  1050f2:	e8 b7 da ff ff       	call   102bae <free_pages>
  1050f7:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  1050fa:	83 ec 08             	sub    $0x8,%esp
  1050fd:	6a 03                	push   $0x3
  1050ff:	ff 75 c4             	pushl  -0x3c(%ebp)
  105102:	e8 a7 da ff ff       	call   102bae <free_pages>
  105107:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  10510a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10510d:	83 c0 04             	add    $0x4,%eax
  105110:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  105117:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10511a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10511d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  105120:	0f a3 10             	bt     %edx,(%eax)
  105123:	19 c0                	sbb    %eax,%eax
  105125:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  105128:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  10512c:	0f 95 c0             	setne  %al
  10512f:	0f b6 c0             	movzbl %al,%eax
  105132:	85 c0                	test   %eax,%eax
  105134:	74 0b                	je     105141 <default_check+0x344>
  105136:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105139:	8b 40 08             	mov    0x8(%eax),%eax
  10513c:	83 f8 01             	cmp    $0x1,%eax
  10513f:	74 19                	je     10515a <default_check+0x35d>
  105141:	68 08 6f 10 00       	push   $0x106f08
  105146:	68 c0 6c 10 00       	push   $0x106cc0
  10514b:	68 44 01 00 00       	push   $0x144
  105150:	68 d5 6c 10 00       	push   $0x106cd5
  105155:	e8 73 b2 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10515a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10515d:	83 c0 04             	add    $0x4,%eax
  105160:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  105167:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10516a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10516d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105170:	0f a3 10             	bt     %edx,(%eax)
  105173:	19 c0                	sbb    %eax,%eax
  105175:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  105178:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  10517c:	0f 95 c0             	setne  %al
  10517f:	0f b6 c0             	movzbl %al,%eax
  105182:	85 c0                	test   %eax,%eax
  105184:	74 0b                	je     105191 <default_check+0x394>
  105186:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105189:	8b 40 08             	mov    0x8(%eax),%eax
  10518c:	83 f8 03             	cmp    $0x3,%eax
  10518f:	74 19                	je     1051aa <default_check+0x3ad>
  105191:	68 30 6f 10 00       	push   $0x106f30
  105196:	68 c0 6c 10 00       	push   $0x106cc0
  10519b:	68 45 01 00 00       	push   $0x145
  1051a0:	68 d5 6c 10 00       	push   $0x106cd5
  1051a5:	e8 23 b2 ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1051aa:	83 ec 0c             	sub    $0xc,%esp
  1051ad:	6a 01                	push   $0x1
  1051af:	e8 bc d9 ff ff       	call   102b70 <alloc_pages>
  1051b4:	83 c4 10             	add    $0x10,%esp
  1051b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1051ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1051bd:	83 e8 14             	sub    $0x14,%eax
  1051c0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1051c3:	74 19                	je     1051de <default_check+0x3e1>
  1051c5:	68 56 6f 10 00       	push   $0x106f56
  1051ca:	68 c0 6c 10 00       	push   $0x106cc0
  1051cf:	68 47 01 00 00       	push   $0x147
  1051d4:	68 d5 6c 10 00       	push   $0x106cd5
  1051d9:	e8 ef b1 ff ff       	call   1003cd <__panic>
    free_page(p0);
  1051de:	83 ec 08             	sub    $0x8,%esp
  1051e1:	6a 01                	push   $0x1
  1051e3:	ff 75 dc             	pushl  -0x24(%ebp)
  1051e6:	e8 c3 d9 ff ff       	call   102bae <free_pages>
  1051eb:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1051ee:	83 ec 0c             	sub    $0xc,%esp
  1051f1:	6a 02                	push   $0x2
  1051f3:	e8 78 d9 ff ff       	call   102b70 <alloc_pages>
  1051f8:	83 c4 10             	add    $0x10,%esp
  1051fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1051fe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105201:	83 c0 14             	add    $0x14,%eax
  105204:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105207:	74 19                	je     105222 <default_check+0x425>
  105209:	68 74 6f 10 00       	push   $0x106f74
  10520e:	68 c0 6c 10 00       	push   $0x106cc0
  105213:	68 49 01 00 00       	push   $0x149
  105218:	68 d5 6c 10 00       	push   $0x106cd5
  10521d:	e8 ab b1 ff ff       	call   1003cd <__panic>

    free_pages(p0, 2);
  105222:	83 ec 08             	sub    $0x8,%esp
  105225:	6a 02                	push   $0x2
  105227:	ff 75 dc             	pushl  -0x24(%ebp)
  10522a:	e8 7f d9 ff ff       	call   102bae <free_pages>
  10522f:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  105232:	83 ec 08             	sub    $0x8,%esp
  105235:	6a 01                	push   $0x1
  105237:	ff 75 c0             	pushl  -0x40(%ebp)
  10523a:	e8 6f d9 ff ff       	call   102bae <free_pages>
  10523f:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  105242:	83 ec 0c             	sub    $0xc,%esp
  105245:	6a 05                	push   $0x5
  105247:	e8 24 d9 ff ff       	call   102b70 <alloc_pages>
  10524c:	83 c4 10             	add    $0x10,%esp
  10524f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105252:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105256:	75 19                	jne    105271 <default_check+0x474>
  105258:	68 94 6f 10 00       	push   $0x106f94
  10525d:	68 c0 6c 10 00       	push   $0x106cc0
  105262:	68 4e 01 00 00       	push   $0x14e
  105267:	68 d5 6c 10 00       	push   $0x106cd5
  10526c:	e8 5c b1 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  105271:	83 ec 0c             	sub    $0xc,%esp
  105274:	6a 01                	push   $0x1
  105276:	e8 f5 d8 ff ff       	call   102b70 <alloc_pages>
  10527b:	83 c4 10             	add    $0x10,%esp
  10527e:	85 c0                	test   %eax,%eax
  105280:	74 19                	je     10529b <default_check+0x49e>
  105282:	68 f2 6d 10 00       	push   $0x106df2
  105287:	68 c0 6c 10 00       	push   $0x106cc0
  10528c:	68 4f 01 00 00       	push   $0x14f
  105291:	68 d5 6c 10 00       	push   $0x106cd5
  105296:	e8 32 b1 ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  10529b:	a1 64 89 11 00       	mov    0x118964,%eax
  1052a0:	85 c0                	test   %eax,%eax
  1052a2:	74 19                	je     1052bd <default_check+0x4c0>
  1052a4:	68 45 6e 10 00       	push   $0x106e45
  1052a9:	68 c0 6c 10 00       	push   $0x106cc0
  1052ae:	68 51 01 00 00       	push   $0x151
  1052b3:	68 d5 6c 10 00       	push   $0x106cd5
  1052b8:	e8 10 b1 ff ff       	call   1003cd <__panic>
    nr_free = nr_free_store;
  1052bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1052c0:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  1052c5:	8b 45 80             	mov    -0x80(%ebp),%eax
  1052c8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1052cb:	a3 5c 89 11 00       	mov    %eax,0x11895c
  1052d0:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  1052d6:	83 ec 08             	sub    $0x8,%esp
  1052d9:	6a 05                	push   $0x5
  1052db:	ff 75 dc             	pushl  -0x24(%ebp)
  1052de:	e8 cb d8 ff ff       	call   102bae <free_pages>
  1052e3:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  1052e6:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1052ed:	eb 1d                	jmp    10530c <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  1052ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052f2:	83 e8 0c             	sub    $0xc,%eax
  1052f5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  1052f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1052fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1052ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105302:	8b 40 08             	mov    0x8(%eax),%eax
  105305:	29 c2                	sub    %eax,%edx
  105307:	89 d0                	mov    %edx,%eax
  105309:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10530c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10530f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  105312:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105315:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  105318:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10531b:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  105322:	75 cb                	jne    1052ef <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  105324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105328:	74 19                	je     105343 <default_check+0x546>
  10532a:	68 b2 6f 10 00       	push   $0x106fb2
  10532f:	68 c0 6c 10 00       	push   $0x106cc0
  105334:	68 5c 01 00 00       	push   $0x15c
  105339:	68 d5 6c 10 00       	push   $0x106cd5
  10533e:	e8 8a b0 ff ff       	call   1003cd <__panic>
    assert(total == 0);
  105343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105347:	74 19                	je     105362 <default_check+0x565>
  105349:	68 bd 6f 10 00       	push   $0x106fbd
  10534e:	68 c0 6c 10 00       	push   $0x106cc0
  105353:	68 5d 01 00 00       	push   $0x15d
  105358:	68 d5 6c 10 00       	push   $0x106cd5
  10535d:	e8 6b b0 ff ff       	call   1003cd <__panic>
}
  105362:	90                   	nop
  105363:	c9                   	leave  
  105364:	c3                   	ret    

00105365 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105365:	55                   	push   %ebp
  105366:	89 e5                	mov    %esp,%ebp
  105368:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10536b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105372:	eb 04                	jmp    105378 <strlen+0x13>
        cnt ++;
  105374:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105378:	8b 45 08             	mov    0x8(%ebp),%eax
  10537b:	8d 50 01             	lea    0x1(%eax),%edx
  10537e:	89 55 08             	mov    %edx,0x8(%ebp)
  105381:	0f b6 00             	movzbl (%eax),%eax
  105384:	84 c0                	test   %al,%al
  105386:	75 ec                	jne    105374 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10538b:	c9                   	leave  
  10538c:	c3                   	ret    

0010538d <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10538d:	55                   	push   %ebp
  10538e:	89 e5                	mov    %esp,%ebp
  105390:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10539a:	eb 04                	jmp    1053a0 <strnlen+0x13>
        cnt ++;
  10539c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1053a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1053a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053a6:	73 10                	jae    1053b8 <strnlen+0x2b>
  1053a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ab:	8d 50 01             	lea    0x1(%eax),%edx
  1053ae:	89 55 08             	mov    %edx,0x8(%ebp)
  1053b1:	0f b6 00             	movzbl (%eax),%eax
  1053b4:	84 c0                	test   %al,%al
  1053b6:	75 e4                	jne    10539c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1053b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1053bb:	c9                   	leave  
  1053bc:	c3                   	ret    

001053bd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1053bd:	55                   	push   %ebp
  1053be:	89 e5                	mov    %esp,%ebp
  1053c0:	57                   	push   %edi
  1053c1:	56                   	push   %esi
  1053c2:	83 ec 20             	sub    $0x20,%esp
  1053c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1053c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1053d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053d7:	89 d1                	mov    %edx,%ecx
  1053d9:	89 c2                	mov    %eax,%edx
  1053db:	89 ce                	mov    %ecx,%esi
  1053dd:	89 d7                	mov    %edx,%edi
  1053df:	ac                   	lods   %ds:(%esi),%al
  1053e0:	aa                   	stos   %al,%es:(%edi)
  1053e1:	84 c0                	test   %al,%al
  1053e3:	75 fa                	jne    1053df <strcpy+0x22>
  1053e5:	89 fa                	mov    %edi,%edx
  1053e7:	89 f1                	mov    %esi,%ecx
  1053e9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1053ec:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1053ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1053f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1053f5:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1053f6:	83 c4 20             	add    $0x20,%esp
  1053f9:	5e                   	pop    %esi
  1053fa:	5f                   	pop    %edi
  1053fb:	5d                   	pop    %ebp
  1053fc:	c3                   	ret    

001053fd <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1053fd:	55                   	push   %ebp
  1053fe:	89 e5                	mov    %esp,%ebp
  105400:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105403:	8b 45 08             	mov    0x8(%ebp),%eax
  105406:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105409:	eb 21                	jmp    10542c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10540b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540e:	0f b6 10             	movzbl (%eax),%edx
  105411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105414:	88 10                	mov    %dl,(%eax)
  105416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105419:	0f b6 00             	movzbl (%eax),%eax
  10541c:	84 c0                	test   %al,%al
  10541e:	74 04                	je     105424 <strncpy+0x27>
            src ++;
  105420:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105424:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105428:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10542c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105430:	75 d9                	jne    10540b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105432:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105435:	c9                   	leave  
  105436:	c3                   	ret    

00105437 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105437:	55                   	push   %ebp
  105438:	89 e5                	mov    %esp,%ebp
  10543a:	57                   	push   %edi
  10543b:	56                   	push   %esi
  10543c:	83 ec 20             	sub    $0x20,%esp
  10543f:	8b 45 08             	mov    0x8(%ebp),%eax
  105442:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105445:	8b 45 0c             	mov    0xc(%ebp),%eax
  105448:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10544b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10544e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105451:	89 d1                	mov    %edx,%ecx
  105453:	89 c2                	mov    %eax,%edx
  105455:	89 ce                	mov    %ecx,%esi
  105457:	89 d7                	mov    %edx,%edi
  105459:	ac                   	lods   %ds:(%esi),%al
  10545a:	ae                   	scas   %es:(%edi),%al
  10545b:	75 08                	jne    105465 <strcmp+0x2e>
  10545d:	84 c0                	test   %al,%al
  10545f:	75 f8                	jne    105459 <strcmp+0x22>
  105461:	31 c0                	xor    %eax,%eax
  105463:	eb 04                	jmp    105469 <strcmp+0x32>
  105465:	19 c0                	sbb    %eax,%eax
  105467:	0c 01                	or     $0x1,%al
  105469:	89 fa                	mov    %edi,%edx
  10546b:	89 f1                	mov    %esi,%ecx
  10546d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105470:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105473:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105476:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105479:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10547a:	83 c4 20             	add    $0x20,%esp
  10547d:	5e                   	pop    %esi
  10547e:	5f                   	pop    %edi
  10547f:	5d                   	pop    %ebp
  105480:	c3                   	ret    

00105481 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105481:	55                   	push   %ebp
  105482:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105484:	eb 0c                	jmp    105492 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105486:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10548a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10548e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105492:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105496:	74 1a                	je     1054b2 <strncmp+0x31>
  105498:	8b 45 08             	mov    0x8(%ebp),%eax
  10549b:	0f b6 00             	movzbl (%eax),%eax
  10549e:	84 c0                	test   %al,%al
  1054a0:	74 10                	je     1054b2 <strncmp+0x31>
  1054a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a5:	0f b6 10             	movzbl (%eax),%edx
  1054a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054ab:	0f b6 00             	movzbl (%eax),%eax
  1054ae:	38 c2                	cmp    %al,%dl
  1054b0:	74 d4                	je     105486 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1054b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054b6:	74 18                	je     1054d0 <strncmp+0x4f>
  1054b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1054bb:	0f b6 00             	movzbl (%eax),%eax
  1054be:	0f b6 d0             	movzbl %al,%edx
  1054c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c4:	0f b6 00             	movzbl (%eax),%eax
  1054c7:	0f b6 c0             	movzbl %al,%eax
  1054ca:	29 c2                	sub    %eax,%edx
  1054cc:	89 d0                	mov    %edx,%eax
  1054ce:	eb 05                	jmp    1054d5 <strncmp+0x54>
  1054d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1054d5:	5d                   	pop    %ebp
  1054d6:	c3                   	ret    

001054d7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1054d7:	55                   	push   %ebp
  1054d8:	89 e5                	mov    %esp,%ebp
  1054da:	83 ec 04             	sub    $0x4,%esp
  1054dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054e0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1054e3:	eb 14                	jmp    1054f9 <strchr+0x22>
        if (*s == c) {
  1054e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e8:	0f b6 00             	movzbl (%eax),%eax
  1054eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1054ee:	75 05                	jne    1054f5 <strchr+0x1e>
            return (char *)s;
  1054f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f3:	eb 13                	jmp    105508 <strchr+0x31>
        }
        s ++;
  1054f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1054f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1054fc:	0f b6 00             	movzbl (%eax),%eax
  1054ff:	84 c0                	test   %al,%al
  105501:	75 e2                	jne    1054e5 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105508:	c9                   	leave  
  105509:	c3                   	ret    

0010550a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10550a:	55                   	push   %ebp
  10550b:	89 e5                	mov    %esp,%ebp
  10550d:	83 ec 04             	sub    $0x4,%esp
  105510:	8b 45 0c             	mov    0xc(%ebp),%eax
  105513:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105516:	eb 0f                	jmp    105527 <strfind+0x1d>
        if (*s == c) {
  105518:	8b 45 08             	mov    0x8(%ebp),%eax
  10551b:	0f b6 00             	movzbl (%eax),%eax
  10551e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105521:	74 10                	je     105533 <strfind+0x29>
            break;
        }
        s ++;
  105523:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105527:	8b 45 08             	mov    0x8(%ebp),%eax
  10552a:	0f b6 00             	movzbl (%eax),%eax
  10552d:	84 c0                	test   %al,%al
  10552f:	75 e7                	jne    105518 <strfind+0xe>
  105531:	eb 01                	jmp    105534 <strfind+0x2a>
        if (*s == c) {
            break;
  105533:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105534:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105537:	c9                   	leave  
  105538:	c3                   	ret    

00105539 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105539:	55                   	push   %ebp
  10553a:	89 e5                	mov    %esp,%ebp
  10553c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10553f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105546:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10554d:	eb 04                	jmp    105553 <strtol+0x1a>
        s ++;
  10554f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105553:	8b 45 08             	mov    0x8(%ebp),%eax
  105556:	0f b6 00             	movzbl (%eax),%eax
  105559:	3c 20                	cmp    $0x20,%al
  10555b:	74 f2                	je     10554f <strtol+0x16>
  10555d:	8b 45 08             	mov    0x8(%ebp),%eax
  105560:	0f b6 00             	movzbl (%eax),%eax
  105563:	3c 09                	cmp    $0x9,%al
  105565:	74 e8                	je     10554f <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105567:	8b 45 08             	mov    0x8(%ebp),%eax
  10556a:	0f b6 00             	movzbl (%eax),%eax
  10556d:	3c 2b                	cmp    $0x2b,%al
  10556f:	75 06                	jne    105577 <strtol+0x3e>
        s ++;
  105571:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105575:	eb 15                	jmp    10558c <strtol+0x53>
    }
    else if (*s == '-') {
  105577:	8b 45 08             	mov    0x8(%ebp),%eax
  10557a:	0f b6 00             	movzbl (%eax),%eax
  10557d:	3c 2d                	cmp    $0x2d,%al
  10557f:	75 0b                	jne    10558c <strtol+0x53>
        s ++, neg = 1;
  105581:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105585:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10558c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105590:	74 06                	je     105598 <strtol+0x5f>
  105592:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105596:	75 24                	jne    1055bc <strtol+0x83>
  105598:	8b 45 08             	mov    0x8(%ebp),%eax
  10559b:	0f b6 00             	movzbl (%eax),%eax
  10559e:	3c 30                	cmp    $0x30,%al
  1055a0:	75 1a                	jne    1055bc <strtol+0x83>
  1055a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a5:	83 c0 01             	add    $0x1,%eax
  1055a8:	0f b6 00             	movzbl (%eax),%eax
  1055ab:	3c 78                	cmp    $0x78,%al
  1055ad:	75 0d                	jne    1055bc <strtol+0x83>
        s += 2, base = 16;
  1055af:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1055b3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1055ba:	eb 2a                	jmp    1055e6 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1055bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1055c0:	75 17                	jne    1055d9 <strtol+0xa0>
  1055c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c5:	0f b6 00             	movzbl (%eax),%eax
  1055c8:	3c 30                	cmp    $0x30,%al
  1055ca:	75 0d                	jne    1055d9 <strtol+0xa0>
        s ++, base = 8;
  1055cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1055d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1055d7:	eb 0d                	jmp    1055e6 <strtol+0xad>
    }
    else if (base == 0) {
  1055d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1055dd:	75 07                	jne    1055e6 <strtol+0xad>
        base = 10;
  1055df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1055e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e9:	0f b6 00             	movzbl (%eax),%eax
  1055ec:	3c 2f                	cmp    $0x2f,%al
  1055ee:	7e 1b                	jle    10560b <strtol+0xd2>
  1055f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f3:	0f b6 00             	movzbl (%eax),%eax
  1055f6:	3c 39                	cmp    $0x39,%al
  1055f8:	7f 11                	jg     10560b <strtol+0xd2>
            dig = *s - '0';
  1055fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fd:	0f b6 00             	movzbl (%eax),%eax
  105600:	0f be c0             	movsbl %al,%eax
  105603:	83 e8 30             	sub    $0x30,%eax
  105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105609:	eb 48                	jmp    105653 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10560b:	8b 45 08             	mov    0x8(%ebp),%eax
  10560e:	0f b6 00             	movzbl (%eax),%eax
  105611:	3c 60                	cmp    $0x60,%al
  105613:	7e 1b                	jle    105630 <strtol+0xf7>
  105615:	8b 45 08             	mov    0x8(%ebp),%eax
  105618:	0f b6 00             	movzbl (%eax),%eax
  10561b:	3c 7a                	cmp    $0x7a,%al
  10561d:	7f 11                	jg     105630 <strtol+0xf7>
            dig = *s - 'a' + 10;
  10561f:	8b 45 08             	mov    0x8(%ebp),%eax
  105622:	0f b6 00             	movzbl (%eax),%eax
  105625:	0f be c0             	movsbl %al,%eax
  105628:	83 e8 57             	sub    $0x57,%eax
  10562b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10562e:	eb 23                	jmp    105653 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105630:	8b 45 08             	mov    0x8(%ebp),%eax
  105633:	0f b6 00             	movzbl (%eax),%eax
  105636:	3c 40                	cmp    $0x40,%al
  105638:	7e 3c                	jle    105676 <strtol+0x13d>
  10563a:	8b 45 08             	mov    0x8(%ebp),%eax
  10563d:	0f b6 00             	movzbl (%eax),%eax
  105640:	3c 5a                	cmp    $0x5a,%al
  105642:	7f 32                	jg     105676 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105644:	8b 45 08             	mov    0x8(%ebp),%eax
  105647:	0f b6 00             	movzbl (%eax),%eax
  10564a:	0f be c0             	movsbl %al,%eax
  10564d:	83 e8 37             	sub    $0x37,%eax
  105650:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105656:	3b 45 10             	cmp    0x10(%ebp),%eax
  105659:	7d 1a                	jge    105675 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  10565b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10565f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105662:	0f af 45 10          	imul   0x10(%ebp),%eax
  105666:	89 c2                	mov    %eax,%edx
  105668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10566b:	01 d0                	add    %edx,%eax
  10566d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105670:	e9 71 ff ff ff       	jmp    1055e6 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105675:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105676:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10567a:	74 08                	je     105684 <strtol+0x14b>
        *endptr = (char *) s;
  10567c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10567f:	8b 55 08             	mov    0x8(%ebp),%edx
  105682:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105684:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105688:	74 07                	je     105691 <strtol+0x158>
  10568a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10568d:	f7 d8                	neg    %eax
  10568f:	eb 03                	jmp    105694 <strtol+0x15b>
  105691:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105694:	c9                   	leave  
  105695:	c3                   	ret    

00105696 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105696:	55                   	push   %ebp
  105697:	89 e5                	mov    %esp,%ebp
  105699:	57                   	push   %edi
  10569a:	83 ec 24             	sub    $0x24,%esp
  10569d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1056a3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1056a7:	8b 55 08             	mov    0x8(%ebp),%edx
  1056aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1056ad:	88 45 f7             	mov    %al,-0x9(%ebp)
  1056b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1056b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1056b6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1056b9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1056bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1056c0:	89 d7                	mov    %edx,%edi
  1056c2:	f3 aa                	rep stos %al,%es:(%edi)
  1056c4:	89 fa                	mov    %edi,%edx
  1056c6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1056c9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1056cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056cf:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1056d0:	83 c4 24             	add    $0x24,%esp
  1056d3:	5f                   	pop    %edi
  1056d4:	5d                   	pop    %ebp
  1056d5:	c3                   	ret    

001056d6 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1056d6:	55                   	push   %ebp
  1056d7:	89 e5                	mov    %esp,%ebp
  1056d9:	57                   	push   %edi
  1056da:	56                   	push   %esi
  1056db:	53                   	push   %ebx
  1056dc:	83 ec 30             	sub    $0x30,%esp
  1056df:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1056ee:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1056f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1056f7:	73 42                	jae    10573b <memmove+0x65>
  1056f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105702:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105708:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10570b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10570e:	c1 e8 02             	shr    $0x2,%eax
  105711:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105719:	89 d7                	mov    %edx,%edi
  10571b:	89 c6                	mov    %eax,%esi
  10571d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10571f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105722:	83 e1 03             	and    $0x3,%ecx
  105725:	74 02                	je     105729 <memmove+0x53>
  105727:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105729:	89 f0                	mov    %esi,%eax
  10572b:	89 fa                	mov    %edi,%edx
  10572d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105730:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105733:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105739:	eb 36                	jmp    105771 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10573b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10573e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105744:	01 c2                	add    %eax,%edx
  105746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105749:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10574c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10574f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105755:	89 c1                	mov    %eax,%ecx
  105757:	89 d8                	mov    %ebx,%eax
  105759:	89 d6                	mov    %edx,%esi
  10575b:	89 c7                	mov    %eax,%edi
  10575d:	fd                   	std    
  10575e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105760:	fc                   	cld    
  105761:	89 f8                	mov    %edi,%eax
  105763:	89 f2                	mov    %esi,%edx
  105765:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105768:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10576b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  10576e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105771:	83 c4 30             	add    $0x30,%esp
  105774:	5b                   	pop    %ebx
  105775:	5e                   	pop    %esi
  105776:	5f                   	pop    %edi
  105777:	5d                   	pop    %ebp
  105778:	c3                   	ret    

00105779 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105779:	55                   	push   %ebp
  10577a:	89 e5                	mov    %esp,%ebp
  10577c:	57                   	push   %edi
  10577d:	56                   	push   %esi
  10577e:	83 ec 20             	sub    $0x20,%esp
  105781:	8b 45 08             	mov    0x8(%ebp),%eax
  105784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105787:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10578d:	8b 45 10             	mov    0x10(%ebp),%eax
  105790:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105796:	c1 e8 02             	shr    $0x2,%eax
  105799:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10579b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a1:	89 d7                	mov    %edx,%edi
  1057a3:	89 c6                	mov    %eax,%esi
  1057a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1057a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1057aa:	83 e1 03             	and    $0x3,%ecx
  1057ad:	74 02                	je     1057b1 <memcpy+0x38>
  1057af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057b1:	89 f0                	mov    %esi,%eax
  1057b3:	89 fa                	mov    %edi,%edx
  1057b5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1057b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1057bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1057be:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1057c1:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1057c2:	83 c4 20             	add    $0x20,%esp
  1057c5:	5e                   	pop    %esi
  1057c6:	5f                   	pop    %edi
  1057c7:	5d                   	pop    %ebp
  1057c8:	c3                   	ret    

001057c9 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1057c9:	55                   	push   %ebp
  1057ca:	89 e5                	mov    %esp,%ebp
  1057cc:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1057cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1057d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1057db:	eb 30                	jmp    10580d <memcmp+0x44>
        if (*s1 != *s2) {
  1057dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057e0:	0f b6 10             	movzbl (%eax),%edx
  1057e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1057e6:	0f b6 00             	movzbl (%eax),%eax
  1057e9:	38 c2                	cmp    %al,%dl
  1057eb:	74 18                	je     105805 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1057ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057f0:	0f b6 00             	movzbl (%eax),%eax
  1057f3:	0f b6 d0             	movzbl %al,%edx
  1057f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1057f9:	0f b6 00             	movzbl (%eax),%eax
  1057fc:	0f b6 c0             	movzbl %al,%eax
  1057ff:	29 c2                	sub    %eax,%edx
  105801:	89 d0                	mov    %edx,%eax
  105803:	eb 1a                	jmp    10581f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105805:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105809:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10580d:	8b 45 10             	mov    0x10(%ebp),%eax
  105810:	8d 50 ff             	lea    -0x1(%eax),%edx
  105813:	89 55 10             	mov    %edx,0x10(%ebp)
  105816:	85 c0                	test   %eax,%eax
  105818:	75 c3                	jne    1057dd <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10581a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10581f:	c9                   	leave  
  105820:	c3                   	ret    

00105821 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105821:	55                   	push   %ebp
  105822:	89 e5                	mov    %esp,%ebp
  105824:	83 ec 38             	sub    $0x38,%esp
  105827:	8b 45 10             	mov    0x10(%ebp),%eax
  10582a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10582d:	8b 45 14             	mov    0x14(%ebp),%eax
  105830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105833:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105836:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105839:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10583c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10583f:	8b 45 18             	mov    0x18(%ebp),%eax
  105842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10584b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10584e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10585b:	74 1c                	je     105879 <printnum+0x58>
  10585d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105860:	ba 00 00 00 00       	mov    $0x0,%edx
  105865:	f7 75 e4             	divl   -0x1c(%ebp)
  105868:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10586b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10586e:	ba 00 00 00 00       	mov    $0x0,%edx
  105873:	f7 75 e4             	divl   -0x1c(%ebp)
  105876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10587c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10587f:	f7 75 e4             	divl   -0x1c(%ebp)
  105882:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105885:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10588b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10588e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105891:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105894:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105897:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10589a:	8b 45 18             	mov    0x18(%ebp),%eax
  10589d:	ba 00 00 00 00       	mov    $0x0,%edx
  1058a2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1058a5:	77 41                	ja     1058e8 <printnum+0xc7>
  1058a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1058aa:	72 05                	jb     1058b1 <printnum+0x90>
  1058ac:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1058af:	77 37                	ja     1058e8 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1058b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1058b4:	83 e8 01             	sub    $0x1,%eax
  1058b7:	83 ec 04             	sub    $0x4,%esp
  1058ba:	ff 75 20             	pushl  0x20(%ebp)
  1058bd:	50                   	push   %eax
  1058be:	ff 75 18             	pushl  0x18(%ebp)
  1058c1:	ff 75 ec             	pushl  -0x14(%ebp)
  1058c4:	ff 75 e8             	pushl  -0x18(%ebp)
  1058c7:	ff 75 0c             	pushl  0xc(%ebp)
  1058ca:	ff 75 08             	pushl  0x8(%ebp)
  1058cd:	e8 4f ff ff ff       	call   105821 <printnum>
  1058d2:	83 c4 20             	add    $0x20,%esp
  1058d5:	eb 1b                	jmp    1058f2 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1058d7:	83 ec 08             	sub    $0x8,%esp
  1058da:	ff 75 0c             	pushl  0xc(%ebp)
  1058dd:	ff 75 20             	pushl  0x20(%ebp)
  1058e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e3:	ff d0                	call   *%eax
  1058e5:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1058e8:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1058ec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1058f0:	7f e5                	jg     1058d7 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1058f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1058f5:	05 78 70 10 00       	add    $0x107078,%eax
  1058fa:	0f b6 00             	movzbl (%eax),%eax
  1058fd:	0f be c0             	movsbl %al,%eax
  105900:	83 ec 08             	sub    $0x8,%esp
  105903:	ff 75 0c             	pushl  0xc(%ebp)
  105906:	50                   	push   %eax
  105907:	8b 45 08             	mov    0x8(%ebp),%eax
  10590a:	ff d0                	call   *%eax
  10590c:	83 c4 10             	add    $0x10,%esp
}
  10590f:	90                   	nop
  105910:	c9                   	leave  
  105911:	c3                   	ret    

00105912 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105912:	55                   	push   %ebp
  105913:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105919:	7e 14                	jle    10592f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10591b:	8b 45 08             	mov    0x8(%ebp),%eax
  10591e:	8b 00                	mov    (%eax),%eax
  105920:	8d 48 08             	lea    0x8(%eax),%ecx
  105923:	8b 55 08             	mov    0x8(%ebp),%edx
  105926:	89 0a                	mov    %ecx,(%edx)
  105928:	8b 50 04             	mov    0x4(%eax),%edx
  10592b:	8b 00                	mov    (%eax),%eax
  10592d:	eb 30                	jmp    10595f <getuint+0x4d>
    }
    else if (lflag) {
  10592f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105933:	74 16                	je     10594b <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105935:	8b 45 08             	mov    0x8(%ebp),%eax
  105938:	8b 00                	mov    (%eax),%eax
  10593a:	8d 48 04             	lea    0x4(%eax),%ecx
  10593d:	8b 55 08             	mov    0x8(%ebp),%edx
  105940:	89 0a                	mov    %ecx,(%edx)
  105942:	8b 00                	mov    (%eax),%eax
  105944:	ba 00 00 00 00       	mov    $0x0,%edx
  105949:	eb 14                	jmp    10595f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10594b:	8b 45 08             	mov    0x8(%ebp),%eax
  10594e:	8b 00                	mov    (%eax),%eax
  105950:	8d 48 04             	lea    0x4(%eax),%ecx
  105953:	8b 55 08             	mov    0x8(%ebp),%edx
  105956:	89 0a                	mov    %ecx,(%edx)
  105958:	8b 00                	mov    (%eax),%eax
  10595a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10595f:	5d                   	pop    %ebp
  105960:	c3                   	ret    

00105961 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105961:	55                   	push   %ebp
  105962:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105964:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105968:	7e 14                	jle    10597e <getint+0x1d>
        return va_arg(*ap, long long);
  10596a:	8b 45 08             	mov    0x8(%ebp),%eax
  10596d:	8b 00                	mov    (%eax),%eax
  10596f:	8d 48 08             	lea    0x8(%eax),%ecx
  105972:	8b 55 08             	mov    0x8(%ebp),%edx
  105975:	89 0a                	mov    %ecx,(%edx)
  105977:	8b 50 04             	mov    0x4(%eax),%edx
  10597a:	8b 00                	mov    (%eax),%eax
  10597c:	eb 28                	jmp    1059a6 <getint+0x45>
    }
    else if (lflag) {
  10597e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105982:	74 12                	je     105996 <getint+0x35>
        return va_arg(*ap, long);
  105984:	8b 45 08             	mov    0x8(%ebp),%eax
  105987:	8b 00                	mov    (%eax),%eax
  105989:	8d 48 04             	lea    0x4(%eax),%ecx
  10598c:	8b 55 08             	mov    0x8(%ebp),%edx
  10598f:	89 0a                	mov    %ecx,(%edx)
  105991:	8b 00                	mov    (%eax),%eax
  105993:	99                   	cltd   
  105994:	eb 10                	jmp    1059a6 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105996:	8b 45 08             	mov    0x8(%ebp),%eax
  105999:	8b 00                	mov    (%eax),%eax
  10599b:	8d 48 04             	lea    0x4(%eax),%ecx
  10599e:	8b 55 08             	mov    0x8(%ebp),%edx
  1059a1:	89 0a                	mov    %ecx,(%edx)
  1059a3:	8b 00                	mov    (%eax),%eax
  1059a5:	99                   	cltd   
    }
}
  1059a6:	5d                   	pop    %ebp
  1059a7:	c3                   	ret    

001059a8 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1059a8:	55                   	push   %ebp
  1059a9:	89 e5                	mov    %esp,%ebp
  1059ab:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1059ae:	8d 45 14             	lea    0x14(%ebp),%eax
  1059b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059b7:	50                   	push   %eax
  1059b8:	ff 75 10             	pushl  0x10(%ebp)
  1059bb:	ff 75 0c             	pushl  0xc(%ebp)
  1059be:	ff 75 08             	pushl  0x8(%ebp)
  1059c1:	e8 06 00 00 00       	call   1059cc <vprintfmt>
  1059c6:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1059c9:	90                   	nop
  1059ca:	c9                   	leave  
  1059cb:	c3                   	ret    

001059cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1059cc:	55                   	push   %ebp
  1059cd:	89 e5                	mov    %esp,%ebp
  1059cf:	56                   	push   %esi
  1059d0:	53                   	push   %ebx
  1059d1:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059d4:	eb 17                	jmp    1059ed <vprintfmt+0x21>
            if (ch == '\0') {
  1059d6:	85 db                	test   %ebx,%ebx
  1059d8:	0f 84 8e 03 00 00    	je     105d6c <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1059de:	83 ec 08             	sub    $0x8,%esp
  1059e1:	ff 75 0c             	pushl  0xc(%ebp)
  1059e4:	53                   	push   %ebx
  1059e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e8:	ff d0                	call   *%eax
  1059ea:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1059f0:	8d 50 01             	lea    0x1(%eax),%edx
  1059f3:	89 55 10             	mov    %edx,0x10(%ebp)
  1059f6:	0f b6 00             	movzbl (%eax),%eax
  1059f9:	0f b6 d8             	movzbl %al,%ebx
  1059fc:	83 fb 25             	cmp    $0x25,%ebx
  1059ff:	75 d5                	jne    1059d6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105a01:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105a05:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105a12:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a1c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a22:	8d 50 01             	lea    0x1(%eax),%edx
  105a25:	89 55 10             	mov    %edx,0x10(%ebp)
  105a28:	0f b6 00             	movzbl (%eax),%eax
  105a2b:	0f b6 d8             	movzbl %al,%ebx
  105a2e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105a31:	83 f8 55             	cmp    $0x55,%eax
  105a34:	0f 87 05 03 00 00    	ja     105d3f <vprintfmt+0x373>
  105a3a:	8b 04 85 9c 70 10 00 	mov    0x10709c(,%eax,4),%eax
  105a41:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105a43:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105a47:	eb d6                	jmp    105a1f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105a49:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105a4d:	eb d0                	jmp    105a1f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105a4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a59:	89 d0                	mov    %edx,%eax
  105a5b:	c1 e0 02             	shl    $0x2,%eax
  105a5e:	01 d0                	add    %edx,%eax
  105a60:	01 c0                	add    %eax,%eax
  105a62:	01 d8                	add    %ebx,%eax
  105a64:	83 e8 30             	sub    $0x30,%eax
  105a67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  105a6d:	0f b6 00             	movzbl (%eax),%eax
  105a70:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105a73:	83 fb 2f             	cmp    $0x2f,%ebx
  105a76:	7e 39                	jle    105ab1 <vprintfmt+0xe5>
  105a78:	83 fb 39             	cmp    $0x39,%ebx
  105a7b:	7f 34                	jg     105ab1 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105a7d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105a81:	eb d3                	jmp    105a56 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105a83:	8b 45 14             	mov    0x14(%ebp),%eax
  105a86:	8d 50 04             	lea    0x4(%eax),%edx
  105a89:	89 55 14             	mov    %edx,0x14(%ebp)
  105a8c:	8b 00                	mov    (%eax),%eax
  105a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105a91:	eb 1f                	jmp    105ab2 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105a93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a97:	79 86                	jns    105a1f <vprintfmt+0x53>
                width = 0;
  105a99:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105aa0:	e9 7a ff ff ff       	jmp    105a1f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105aa5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105aac:	e9 6e ff ff ff       	jmp    105a1f <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105ab1:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ab6:	0f 89 63 ff ff ff    	jns    105a1f <vprintfmt+0x53>
                width = precision, precision = -1;
  105abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105abf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ac2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105ac9:	e9 51 ff ff ff       	jmp    105a1f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105ace:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105ad2:	e9 48 ff ff ff       	jmp    105a1f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  105ada:	8d 50 04             	lea    0x4(%eax),%edx
  105add:	89 55 14             	mov    %edx,0x14(%ebp)
  105ae0:	8b 00                	mov    (%eax),%eax
  105ae2:	83 ec 08             	sub    $0x8,%esp
  105ae5:	ff 75 0c             	pushl  0xc(%ebp)
  105ae8:	50                   	push   %eax
  105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  105aec:	ff d0                	call   *%eax
  105aee:	83 c4 10             	add    $0x10,%esp
            break;
  105af1:	e9 71 02 00 00       	jmp    105d67 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105af6:	8b 45 14             	mov    0x14(%ebp),%eax
  105af9:	8d 50 04             	lea    0x4(%eax),%edx
  105afc:	89 55 14             	mov    %edx,0x14(%ebp)
  105aff:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105b01:	85 db                	test   %ebx,%ebx
  105b03:	79 02                	jns    105b07 <vprintfmt+0x13b>
                err = -err;
  105b05:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105b07:	83 fb 06             	cmp    $0x6,%ebx
  105b0a:	7f 0b                	jg     105b17 <vprintfmt+0x14b>
  105b0c:	8b 34 9d 5c 70 10 00 	mov    0x10705c(,%ebx,4),%esi
  105b13:	85 f6                	test   %esi,%esi
  105b15:	75 19                	jne    105b30 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  105b17:	53                   	push   %ebx
  105b18:	68 89 70 10 00       	push   $0x107089
  105b1d:	ff 75 0c             	pushl  0xc(%ebp)
  105b20:	ff 75 08             	pushl  0x8(%ebp)
  105b23:	e8 80 fe ff ff       	call   1059a8 <printfmt>
  105b28:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105b2b:	e9 37 02 00 00       	jmp    105d67 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105b30:	56                   	push   %esi
  105b31:	68 92 70 10 00       	push   $0x107092
  105b36:	ff 75 0c             	pushl  0xc(%ebp)
  105b39:	ff 75 08             	pushl  0x8(%ebp)
  105b3c:	e8 67 fe ff ff       	call   1059a8 <printfmt>
  105b41:	83 c4 10             	add    $0x10,%esp
            }
            break;
  105b44:	e9 1e 02 00 00       	jmp    105d67 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105b49:	8b 45 14             	mov    0x14(%ebp),%eax
  105b4c:	8d 50 04             	lea    0x4(%eax),%edx
  105b4f:	89 55 14             	mov    %edx,0x14(%ebp)
  105b52:	8b 30                	mov    (%eax),%esi
  105b54:	85 f6                	test   %esi,%esi
  105b56:	75 05                	jne    105b5d <vprintfmt+0x191>
                p = "(null)";
  105b58:	be 95 70 10 00       	mov    $0x107095,%esi
            }
            if (width > 0 && padc != '-') {
  105b5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b61:	7e 76                	jle    105bd9 <vprintfmt+0x20d>
  105b63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105b67:	74 70                	je     105bd9 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b6c:	83 ec 08             	sub    $0x8,%esp
  105b6f:	50                   	push   %eax
  105b70:	56                   	push   %esi
  105b71:	e8 17 f8 ff ff       	call   10538d <strnlen>
  105b76:	83 c4 10             	add    $0x10,%esp
  105b79:	89 c2                	mov    %eax,%edx
  105b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b7e:	29 d0                	sub    %edx,%eax
  105b80:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b83:	eb 17                	jmp    105b9c <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105b85:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105b89:	83 ec 08             	sub    $0x8,%esp
  105b8c:	ff 75 0c             	pushl  0xc(%ebp)
  105b8f:	50                   	push   %eax
  105b90:	8b 45 08             	mov    0x8(%ebp),%eax
  105b93:	ff d0                	call   *%eax
  105b95:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105b98:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ba0:	7f e3                	jg     105b85 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ba2:	eb 35                	jmp    105bd9 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  105ba4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105ba8:	74 1c                	je     105bc6 <vprintfmt+0x1fa>
  105baa:	83 fb 1f             	cmp    $0x1f,%ebx
  105bad:	7e 05                	jle    105bb4 <vprintfmt+0x1e8>
  105baf:	83 fb 7e             	cmp    $0x7e,%ebx
  105bb2:	7e 12                	jle    105bc6 <vprintfmt+0x1fa>
                    putch('?', putdat);
  105bb4:	83 ec 08             	sub    $0x8,%esp
  105bb7:	ff 75 0c             	pushl  0xc(%ebp)
  105bba:	6a 3f                	push   $0x3f
  105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbf:	ff d0                	call   *%eax
  105bc1:	83 c4 10             	add    $0x10,%esp
  105bc4:	eb 0f                	jmp    105bd5 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  105bc6:	83 ec 08             	sub    $0x8,%esp
  105bc9:	ff 75 0c             	pushl  0xc(%ebp)
  105bcc:	53                   	push   %ebx
  105bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd0:	ff d0                	call   *%eax
  105bd2:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105bd5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105bd9:	89 f0                	mov    %esi,%eax
  105bdb:	8d 70 01             	lea    0x1(%eax),%esi
  105bde:	0f b6 00             	movzbl (%eax),%eax
  105be1:	0f be d8             	movsbl %al,%ebx
  105be4:	85 db                	test   %ebx,%ebx
  105be6:	74 26                	je     105c0e <vprintfmt+0x242>
  105be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105bec:	78 b6                	js     105ba4 <vprintfmt+0x1d8>
  105bee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105bf6:	79 ac                	jns    105ba4 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105bf8:	eb 14                	jmp    105c0e <vprintfmt+0x242>
                putch(' ', putdat);
  105bfa:	83 ec 08             	sub    $0x8,%esp
  105bfd:	ff 75 0c             	pushl  0xc(%ebp)
  105c00:	6a 20                	push   $0x20
  105c02:	8b 45 08             	mov    0x8(%ebp),%eax
  105c05:	ff d0                	call   *%eax
  105c07:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105c0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c12:	7f e6                	jg     105bfa <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  105c14:	e9 4e 01 00 00       	jmp    105d67 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105c19:	83 ec 08             	sub    $0x8,%esp
  105c1c:	ff 75 e0             	pushl  -0x20(%ebp)
  105c1f:	8d 45 14             	lea    0x14(%ebp),%eax
  105c22:	50                   	push   %eax
  105c23:	e8 39 fd ff ff       	call   105961 <getint>
  105c28:	83 c4 10             	add    $0x10,%esp
  105c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c37:	85 d2                	test   %edx,%edx
  105c39:	79 23                	jns    105c5e <vprintfmt+0x292>
                putch('-', putdat);
  105c3b:	83 ec 08             	sub    $0x8,%esp
  105c3e:	ff 75 0c             	pushl  0xc(%ebp)
  105c41:	6a 2d                	push   $0x2d
  105c43:	8b 45 08             	mov    0x8(%ebp),%eax
  105c46:	ff d0                	call   *%eax
  105c48:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c51:	f7 d8                	neg    %eax
  105c53:	83 d2 00             	adc    $0x0,%edx
  105c56:	f7 da                	neg    %edx
  105c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105c5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105c65:	e9 9f 00 00 00       	jmp    105d09 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105c6a:	83 ec 08             	sub    $0x8,%esp
  105c6d:	ff 75 e0             	pushl  -0x20(%ebp)
  105c70:	8d 45 14             	lea    0x14(%ebp),%eax
  105c73:	50                   	push   %eax
  105c74:	e8 99 fc ff ff       	call   105912 <getuint>
  105c79:	83 c4 10             	add    $0x10,%esp
  105c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105c82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105c89:	eb 7e                	jmp    105d09 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105c8b:	83 ec 08             	sub    $0x8,%esp
  105c8e:	ff 75 e0             	pushl  -0x20(%ebp)
  105c91:	8d 45 14             	lea    0x14(%ebp),%eax
  105c94:	50                   	push   %eax
  105c95:	e8 78 fc ff ff       	call   105912 <getuint>
  105c9a:	83 c4 10             	add    $0x10,%esp
  105c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ca0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105ca3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105caa:	eb 5d                	jmp    105d09 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  105cac:	83 ec 08             	sub    $0x8,%esp
  105caf:	ff 75 0c             	pushl  0xc(%ebp)
  105cb2:	6a 30                	push   $0x30
  105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb7:	ff d0                	call   *%eax
  105cb9:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  105cbc:	83 ec 08             	sub    $0x8,%esp
  105cbf:	ff 75 0c             	pushl  0xc(%ebp)
  105cc2:	6a 78                	push   $0x78
  105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc7:	ff d0                	call   *%eax
  105cc9:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  105ccf:	8d 50 04             	lea    0x4(%eax),%edx
  105cd2:	89 55 14             	mov    %edx,0x14(%ebp)
  105cd5:	8b 00                	mov    (%eax),%eax
  105cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ce1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105ce8:	eb 1f                	jmp    105d09 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105cea:	83 ec 08             	sub    $0x8,%esp
  105ced:	ff 75 e0             	pushl  -0x20(%ebp)
  105cf0:	8d 45 14             	lea    0x14(%ebp),%eax
  105cf3:	50                   	push   %eax
  105cf4:	e8 19 fc ff ff       	call   105912 <getuint>
  105cf9:	83 c4 10             	add    $0x10,%esp
  105cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105d02:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105d09:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d10:	83 ec 04             	sub    $0x4,%esp
  105d13:	52                   	push   %edx
  105d14:	ff 75 e8             	pushl  -0x18(%ebp)
  105d17:	50                   	push   %eax
  105d18:	ff 75 f4             	pushl  -0xc(%ebp)
  105d1b:	ff 75 f0             	pushl  -0x10(%ebp)
  105d1e:	ff 75 0c             	pushl  0xc(%ebp)
  105d21:	ff 75 08             	pushl  0x8(%ebp)
  105d24:	e8 f8 fa ff ff       	call   105821 <printnum>
  105d29:	83 c4 20             	add    $0x20,%esp
            break;
  105d2c:	eb 39                	jmp    105d67 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105d2e:	83 ec 08             	sub    $0x8,%esp
  105d31:	ff 75 0c             	pushl  0xc(%ebp)
  105d34:	53                   	push   %ebx
  105d35:	8b 45 08             	mov    0x8(%ebp),%eax
  105d38:	ff d0                	call   *%eax
  105d3a:	83 c4 10             	add    $0x10,%esp
            break;
  105d3d:	eb 28                	jmp    105d67 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105d3f:	83 ec 08             	sub    $0x8,%esp
  105d42:	ff 75 0c             	pushl  0xc(%ebp)
  105d45:	6a 25                	push   $0x25
  105d47:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4a:	ff d0                	call   *%eax
  105d4c:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  105d4f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105d53:	eb 04                	jmp    105d59 <vprintfmt+0x38d>
  105d55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105d59:	8b 45 10             	mov    0x10(%ebp),%eax
  105d5c:	83 e8 01             	sub    $0x1,%eax
  105d5f:	0f b6 00             	movzbl (%eax),%eax
  105d62:	3c 25                	cmp    $0x25,%al
  105d64:	75 ef                	jne    105d55 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105d66:	90                   	nop
        }
    }
  105d67:	e9 68 fc ff ff       	jmp    1059d4 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  105d6c:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  105d70:	5b                   	pop    %ebx
  105d71:	5e                   	pop    %esi
  105d72:	5d                   	pop    %ebp
  105d73:	c3                   	ret    

00105d74 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105d74:	55                   	push   %ebp
  105d75:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d7a:	8b 40 08             	mov    0x8(%eax),%eax
  105d7d:	8d 50 01             	lea    0x1(%eax),%edx
  105d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d83:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d89:	8b 10                	mov    (%eax),%edx
  105d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d8e:	8b 40 04             	mov    0x4(%eax),%eax
  105d91:	39 c2                	cmp    %eax,%edx
  105d93:	73 12                	jae    105da7 <sprintputch+0x33>
        *b->buf ++ = ch;
  105d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d98:	8b 00                	mov    (%eax),%eax
  105d9a:	8d 48 01             	lea    0x1(%eax),%ecx
  105d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105da0:	89 0a                	mov    %ecx,(%edx)
  105da2:	8b 55 08             	mov    0x8(%ebp),%edx
  105da5:	88 10                	mov    %dl,(%eax)
    }
}
  105da7:	90                   	nop
  105da8:	5d                   	pop    %ebp
  105da9:	c3                   	ret    

00105daa <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105daa:	55                   	push   %ebp
  105dab:	89 e5                	mov    %esp,%ebp
  105dad:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105db0:	8d 45 14             	lea    0x14(%ebp),%eax
  105db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105db9:	50                   	push   %eax
  105dba:	ff 75 10             	pushl  0x10(%ebp)
  105dbd:	ff 75 0c             	pushl  0xc(%ebp)
  105dc0:	ff 75 08             	pushl  0x8(%ebp)
  105dc3:	e8 0b 00 00 00       	call   105dd3 <vsnprintf>
  105dc8:	83 c4 10             	add    $0x10,%esp
  105dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105dd1:	c9                   	leave  
  105dd2:	c3                   	ret    

00105dd3 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105dd3:	55                   	push   %ebp
  105dd4:	89 e5                	mov    %esp,%ebp
  105dd6:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  105ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de2:	8d 50 ff             	lea    -0x1(%eax),%edx
  105de5:	8b 45 08             	mov    0x8(%ebp),%eax
  105de8:	01 d0                	add    %edx,%eax
  105dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105df4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105df8:	74 0a                	je     105e04 <vsnprintf+0x31>
  105dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e00:	39 c2                	cmp    %eax,%edx
  105e02:	76 07                	jbe    105e0b <vsnprintf+0x38>
        return -E_INVAL;
  105e04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105e09:	eb 20                	jmp    105e2b <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105e0b:	ff 75 14             	pushl  0x14(%ebp)
  105e0e:	ff 75 10             	pushl  0x10(%ebp)
  105e11:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105e14:	50                   	push   %eax
  105e15:	68 74 5d 10 00       	push   $0x105d74
  105e1a:	e8 ad fb ff ff       	call   1059cc <vprintfmt>
  105e1f:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e25:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105e2b:	c9                   	leave  
  105e2c:	c3                   	ret    
