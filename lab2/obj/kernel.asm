
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 48 56 00 00       	call   c0105696 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 53 15 00 00       	call   c01015a9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 40 5e 10 c0 	movl   $0xc0105e40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 5c 5e 10 c0       	push   $0xc0105e5c
c0100068:	e8 fa 01 00 00       	call   c0100267 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 7c 08 00 00       	call   c01008f1 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 b4 30 00 00       	call   c0103133 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 97 16 00 00       	call   c010171b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 f8 17 00 00       	call   c0101881 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 c2 0c 00 00       	call   c0100d50 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 c5 17 00 00       	call   c0101858 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 95 0c 00 00       	call   c0100d3e <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 61 5e 10 c0       	push   $0xc0105e61
c010013c:	e8 26 01 00 00       	call   c0100267 <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 6f 5e 10 c0       	push   $0xc0105e6f
c010015a:	e8 08 01 00 00       	call   c0100267 <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 7d 5e 10 c0       	push   $0xc0105e7d
c0100178:	e8 ea 00 00 00       	call   c0100267 <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 8b 5e 10 c0       	push   $0xc0105e8b
c0100196:	e8 cc 00 00 00       	call   c0100267 <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 99 5e 10 c0       	push   $0xc0105e99
c01001b4:	e8 ae 00 00 00       	call   c0100267 <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001cf:	90                   	nop
c01001d0:	5d                   	pop    %ebp
c01001d1:	c3                   	ret    

c01001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d2:	55                   	push   %ebp
c01001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001d5:	90                   	nop
c01001d6:	5d                   	pop    %ebp
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
c01001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001de:	e8 2c ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e3:	83 ec 0c             	sub    $0xc,%esp
c01001e6:	68 a8 5e 10 c0       	push   $0xc0105ea8
c01001eb:	e8 77 00 00 00       	call   c0100267 <cprintf>
c01001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f3:	e8 d4 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001f8:	e8 12 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c01001fd:	83 ec 0c             	sub    $0xc,%esp
c0100200:	68 c8 5e 10 c0       	push   $0xc0105ec8
c0100205:	e8 5d 00 00 00       	call   c0100267 <cprintf>
c010020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010020d:	e8 c0 ff ff ff       	call   c01001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100212:	e8 f8 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c0100217:	90                   	nop
c0100218:	c9                   	leave  
c0100219:	c3                   	ret    

c010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	ff 75 08             	pushl  0x8(%ebp)
c0100226:	e8 af 13 00 00       	call   c01015da <cons_putc>
c010022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010022e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100231:	8b 00                	mov    (%eax),%eax
c0100233:	8d 50 01             	lea    0x1(%eax),%edx
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	89 10                	mov    %edx,(%eax)
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024b:	ff 75 0c             	pushl  0xc(%ebp)
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100254:	50                   	push   %eax
c0100255:	68 1a 02 10 c0       	push   $0xc010021a
c010025a:	e8 6d 57 00 00       	call   c01059cc <vprintfmt>
c010025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010026d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100276:	83 ec 08             	sub    $0x8,%esp
c0100279:	50                   	push   %eax
c010027a:	ff 75 08             	pushl  0x8(%ebp)
c010027d:	e8 bc ff ff ff       	call   c010023e <vcprintf>
c0100282:	83 c4 10             	add    $0x10,%esp
c0100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100293:	83 ec 0c             	sub    $0xc,%esp
c0100296:	ff 75 08             	pushl  0x8(%ebp)
c0100299:	e8 3c 13 00 00       	call   c01015da <cons_putc>
c010029e:	83 c4 10             	add    $0x10,%esp
}
c01002a1:	90                   	nop
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b1:	eb 14                	jmp    c01002c7 <cputs+0x23>
        cputch(c, &cnt);
c01002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002b7:	83 ec 08             	sub    $0x8,%esp
c01002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002bd:	52                   	push   %edx
c01002be:	50                   	push   %eax
c01002bf:	e8 56 ff ff ff       	call   c010021a <cputch>
c01002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ca:	8d 50 01             	lea    0x1(%eax),%edx
c01002cd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d0:	0f b6 00             	movzbl (%eax),%eax
c01002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002da:	75 d7                	jne    c01002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002dc:	83 ec 08             	sub    $0x8,%esp
c01002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e2:	50                   	push   %eax
c01002e3:	6a 0a                	push   $0xa
c01002e5:	e8 30 ff ff ff       	call   c010021a <cputch>
c01002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f0:	c9                   	leave  
c01002f1:	c3                   	ret    

c01002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f2:	55                   	push   %ebp
c01002f3:	89 e5                	mov    %esp,%ebp
c01002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002f8:	e8 26 13 00 00       	call   c0101623 <cons_getc>
c01002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100304:	74 f2                	je     c01002f8 <getchar+0x6>
        /* do nothing */;
    return c;
c0100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100315:	74 13                	je     c010032a <readline+0x1f>
        cprintf("%s", prompt);
c0100317:	83 ec 08             	sub    $0x8,%esp
c010031a:	ff 75 08             	pushl  0x8(%ebp)
c010031d:	68 e7 5e 10 c0       	push   $0xc0105ee7
c0100322:	e8 40 ff ff ff       	call   c0100267 <cprintf>
c0100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100331:	e8 bc ff ff ff       	call   c01002f2 <getchar>
c0100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010033d:	79 0a                	jns    c0100349 <readline+0x3e>
            return NULL;
c010033f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100344:	e9 82 00 00 00       	jmp    c01003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010034d:	7e 2b                	jle    c010037a <readline+0x6f>
c010034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100356:	7f 22                	jg     c010037a <readline+0x6f>
            cputchar(c);
c0100358:	83 ec 0c             	sub    $0xc,%esp
c010035b:	ff 75 f0             	pushl  -0x10(%ebp)
c010035e:	e8 2a ff ff ff       	call   c010028d <cputchar>
c0100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100369:	8d 50 01             	lea    0x1(%eax),%edx
c010036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100372:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100378:	eb 4c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010037e:	75 1a                	jne    c010039a <readline+0x8f>
c0100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100384:	7e 14                	jle    c010039a <readline+0x8f>
            cputchar(c);
c0100386:	83 ec 0c             	sub    $0xc,%esp
c0100389:	ff 75 f0             	pushl  -0x10(%ebp)
c010038c:	e8 fc fe ff ff       	call   c010028d <cputchar>
c0100391:	83 c4 10             	add    $0x10,%esp
            i --;
c0100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100398:	eb 2c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010039e:	74 06                	je     c01003a6 <readline+0x9b>
c01003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a4:	75 8b                	jne    c0100331 <readline+0x26>
            cputchar(c);
c01003a6:	83 ec 0c             	sub    $0xc,%esp
c01003a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003ac:	e8 dc fe ff ff       	call   c010028d <cputchar>
c01003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b7:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003bf:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003c4:	eb 05                	jmp    c01003cb <readline+0xc0>
        }
    }
c01003c6:	e9 66 ff ff ff       	jmp    c0100331 <readline+0x26>
}
c01003cb:	c9                   	leave  
c01003cc:	c3                   	ret    

c01003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003cd:	55                   	push   %ebp
c01003ce:	89 e5                	mov    %esp,%ebp
c01003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003d8:	85 c0                	test   %eax,%eax
c01003da:	75 4a                	jne    c0100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003dc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003ec:	83 ec 04             	sub    $0x4,%esp
c01003ef:	ff 75 0c             	pushl  0xc(%ebp)
c01003f2:	ff 75 08             	pushl  0x8(%ebp)
c01003f5:	68 ea 5e 10 c0       	push   $0xc0105eea
c01003fa:	e8 68 fe ff ff       	call   c0100267 <cprintf>
c01003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100405:	83 ec 08             	sub    $0x8,%esp
c0100408:	50                   	push   %eax
c0100409:	ff 75 10             	pushl  0x10(%ebp)
c010040c:	e8 2d fe ff ff       	call   c010023e <vcprintf>
c0100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100414:	83 ec 0c             	sub    $0xc,%esp
c0100417:	68 06 5f 10 c0       	push   $0xc0105f06
c010041c:	e8 46 fe ff ff       	call   c0100267 <cprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
c0100424:	eb 01                	jmp    c0100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100427:	e8 33 14 00 00       	call   c010185f <intr_disable>
    while (1) {
        kmonitor(NULL);
c010042c:	83 ec 0c             	sub    $0xc,%esp
c010042f:	6a 00                	push   $0x0
c0100431:	e8 2e 08 00 00       	call   c0100c64 <kmonitor>
c0100436:	83 c4 10             	add    $0x10,%esp
    }
c0100439:	eb f1                	jmp    c010042c <__panic+0x5f>

c010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043b:	55                   	push   %ebp
c010043c:	89 e5                	mov    %esp,%ebp
c010043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100441:	8d 45 14             	lea    0x14(%ebp),%eax
c0100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100447:	83 ec 04             	sub    $0x4,%esp
c010044a:	ff 75 0c             	pushl  0xc(%ebp)
c010044d:	ff 75 08             	pushl  0x8(%ebp)
c0100450:	68 08 5f 10 c0       	push   $0xc0105f08
c0100455:	e8 0d fe ff ff       	call   c0100267 <cprintf>
c010045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100460:	83 ec 08             	sub    $0x8,%esp
c0100463:	50                   	push   %eax
c0100464:	ff 75 10             	pushl  0x10(%ebp)
c0100467:	e8 d2 fd ff ff       	call   c010023e <vcprintf>
c010046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010046f:	83 ec 0c             	sub    $0xc,%esp
c0100472:	68 06 5f 10 c0       	push   $0xc0105f06
c0100477:	e8 eb fd ff ff       	call   c0100267 <cprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010047f:	90                   	nop
c0100480:	c9                   	leave  
c0100481:	c3                   	ret    

c0100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100482:	55                   	push   %ebp
c0100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100485:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010048a:	5d                   	pop    %ebp
c010048b:	c3                   	ret    

c010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010048c:	55                   	push   %ebp
c010048d:	89 e5                	mov    %esp,%ebp
c010048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 00                	mov    (%eax),%eax
c0100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049a:	8b 45 10             	mov    0x10(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004a9:	e9 d2 00 00 00       	jmp    c0100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	c1 ea 1f             	shr    $0x1f,%edx
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	d1 f8                	sar    %eax
c01004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004c8:	eb 04                	jmp    c01004ce <stab_binsearch+0x42>
            m --;
c01004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d4:	7c 1f                	jl     c01004f5 <stab_binsearch+0x69>
c01004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d9:	89 d0                	mov    %edx,%eax
c01004db:	01 c0                	add    %eax,%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	c1 e0 02             	shl    $0x2,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ed:	0f b6 c0             	movzbl %al,%eax
c01004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f3:	75 d5                	jne    c01004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fb:	7d 0b                	jge    c0100508 <stab_binsearch+0x7c>
            l = true_m + 1;
c01004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100500:	83 c0 01             	add    $0x1,%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100506:	eb 78                	jmp    c0100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	8b 40 08             	mov    0x8(%eax),%eax
c0100525:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100528:	73 13                	jae    c010053d <stab_binsearch+0xb1>
            *region_left = m;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053b:	eb 43                	jmp    c0100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 d0                	mov    %edx,%eax
c0100542:	01 c0                	add    %eax,%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	c1 e0 02             	shl    $0x2,%eax
c0100549:	89 c2                	mov    %eax,%edx
c010054b:	8b 45 08             	mov    0x8(%ebp),%eax
c010054e:	01 d0                	add    %edx,%eax
c0100550:	8b 40 08             	mov    0x8(%eax),%eax
c0100553:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100556:	76 16                	jbe    c010056e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010055e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	83 e8 01             	sub    $0x1,%eax
c0100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010056c:	eb 12                	jmp    c0100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010056e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100574:	89 10                	mov    %edx,(%eax)
            l = m;
c0100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100586:	0f 8e 22 ff ff ff    	jle    c01004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c010058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100590:	75 0f                	jne    c01005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	8b 00                	mov    (%eax),%eax
c0100597:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059a:	8b 45 10             	mov    0x10(%ebp),%eax
c010059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010059f:	eb 3f                	jmp    c01005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a4:	8b 00                	mov    (%eax),%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005a9:	eb 04                	jmp    c01005af <stab_binsearch+0x123>
c01005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 00                	mov    (%eax),%eax
c01005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005b7:	7d 1f                	jge    c01005d8 <stab_binsearch+0x14c>
c01005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005bc:	89 d0                	mov    %edx,%eax
c01005be:	01 c0                	add    %eax,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	c1 e0 02             	shl    $0x2,%eax
c01005c5:	89 c2                	mov    %eax,%edx
c01005c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ca:	01 d0                	add    %edx,%eax
c01005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d0:	0f b6 c0             	movzbl %al,%eax
c01005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005d6:	75 d3                	jne    c01005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005de:	89 10                	mov    %edx,(%eax)
    }
}
c01005e0:	90                   	nop
c01005e1:	c9                   	leave  
c01005e2:	c3                   	ret    

c01005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e3:	55                   	push   %ebp
c01005e4:	89 e5                	mov    %esp,%ebp
c01005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	c7 00 28 5f 10 c0    	movl   $0xc0105f28,(%eax)
    info->eip_line = 0;
c01005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c01005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ff:	c7 40 08 28 5f 10 c0 	movl   $0xc0105f28,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	8b 55 08             	mov    0x8(%ebp),%edx
c0100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100623:	c7 45 f4 f4 71 10 c0 	movl   $0xc01071f4,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062a:	c7 45 f0 0c 23 11 c0 	movl   $0xc011230c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100631:	c7 45 ec 0d 23 11 c0 	movl   $0xc011230d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100638:	c7 45 e8 45 4e 11 c0 	movl   $0xc0114e45,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100645:	76 0d                	jbe    c0100654 <debuginfo_eip+0x71>
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	83 e8 01             	sub    $0x1,%eax
c010064d:	0f b6 00             	movzbl (%eax),%eax
c0100650:	84 c0                	test   %al,%al
c0100652:	74 0a                	je     c010065e <debuginfo_eip+0x7b>
        return -1;
c0100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100659:	e9 91 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066b:	29 c2                	sub    %eax,%edx
c010066d:	89 d0                	mov    %edx,%eax
c010066f:	c1 f8 02             	sar    $0x2,%eax
c0100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100678:	83 e8 01             	sub    $0x1,%eax
c010067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010067e:	ff 75 08             	pushl  0x8(%ebp)
c0100681:	6a 64                	push   $0x64
c0100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100686:	50                   	push   %eax
c0100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	ff 75 f4             	pushl  -0xc(%ebp)
c010068e:	e8 f9 fd ff ff       	call   c010048c <stab_binsearch>
c0100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100699:	85 c0                	test   %eax,%eax
c010069b:	75 0a                	jne    c01006a7 <debuginfo_eip+0xc4>
        return -1;
c010069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a2:	e9 48 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b3:	ff 75 08             	pushl  0x8(%ebp)
c01006b6:	6a 24                	push   $0x24
c01006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bb:	50                   	push   %eax
c01006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c3:	e8 c4 fd ff ff       	call   c010048c <stab_binsearch>
c01006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d1:	39 c2                	cmp    %eax,%edx
c01006d3:	7f 7c                	jg     c0100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d8:	89 c2                	mov    %eax,%edx
c01006da:	89 d0                	mov    %edx,%eax
c01006dc:	01 c0                	add    %eax,%eax
c01006de:	01 d0                	add    %edx,%eax
c01006e0:	c1 e0 02             	shl    $0x2,%eax
c01006e3:	89 c2                	mov    %eax,%edx
c01006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e8:	01 d0                	add    %edx,%eax
c01006ea:	8b 00                	mov    (%eax),%eax
c01006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f2:	29 d1                	sub    %edx,%ecx
c01006f4:	89 ca                	mov    %ecx,%edx
c01006f6:	39 d0                	cmp    %edx,%eax
c01006f8:	73 22                	jae    c010071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fd:	89 c2                	mov    %eax,%edx
c01006ff:	89 d0                	mov    %edx,%eax
c0100701:	01 c0                	add    %eax,%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	c1 e0 02             	shl    $0x2,%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070d:	01 d0                	add    %edx,%eax
c010070f:	8b 10                	mov    (%eax),%edx
c0100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100714:	01 c2                	add    %eax,%edx
c0100716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	89 d0                	mov    %edx,%eax
c0100723:	01 c0                	add    %eax,%eax
c0100725:	01 d0                	add    %edx,%eax
c0100727:	c1 e0 02             	shl    $0x2,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072f:	01 d0                	add    %edx,%eax
c0100731:	8b 50 08             	mov    0x8(%eax),%edx
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073d:	8b 40 10             	mov    0x10(%eax),%eax
c0100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010074f:	eb 15                	jmp    c0100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 55 08             	mov    0x8(%ebp),%edx
c0100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8b 40 08             	mov    0x8(%eax),%eax
c010076c:	83 ec 08             	sub    $0x8,%esp
c010076f:	6a 3a                	push   $0x3a
c0100771:	50                   	push   %eax
c0100772:	e8 93 4d 00 00       	call   c010550a <strfind>
c0100777:	83 c4 10             	add    $0x10,%esp
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 40 08             	mov    0x8(%eax),%eax
c0100782:	29 c2                	sub    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078a:	83 ec 0c             	sub    $0xc,%esp
c010078d:	ff 75 08             	pushl  0x8(%ebp)
c0100790:	6a 44                	push   $0x44
c0100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100795:	50                   	push   %eax
c0100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	ff 75 f4             	pushl  -0xc(%ebp)
c010079d:	e8 ea fc ff ff       	call   c010048c <stab_binsearch>
c01007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ab:	39 c2                	cmp    %eax,%edx
c01007ad:	7f 24                	jg     c01007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007c8:	0f b7 d0             	movzwl %ax,%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d1:	eb 13                	jmp    c01007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007d8:	e9 12 01 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e0:	83 e8 01             	sub    $0x1,%eax
c01007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ec:	39 c2                	cmp    %eax,%edx
c01007ee:	7c 56                	jl     c0100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f3:	89 c2                	mov    %eax,%edx
c01007f5:	89 d0                	mov    %edx,%eax
c01007f7:	01 c0                	add    %eax,%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	c1 e0 02             	shl    $0x2,%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100803:	01 d0                	add    %edx,%eax
c0100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100809:	3c 84                	cmp    $0x84,%al
c010080b:	74 39                	je     c0100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100826:	3c 64                	cmp    $0x64,%al
c0100828:	75 b3                	jne    c01007dd <debuginfo_eip+0x1fa>
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	89 d0                	mov    %edx,%eax
c0100831:	01 c0                	add    %eax,%eax
c0100833:	01 d0                	add    %edx,%eax
c0100835:	c1 e0 02             	shl    $0x2,%eax
c0100838:	89 c2                	mov    %eax,%edx
c010083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083d:	01 d0                	add    %edx,%eax
c010083f:	8b 40 08             	mov    0x8(%eax),%eax
c0100842:	85 c0                	test   %eax,%eax
c0100844:	74 97                	je     c01007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084c:	39 c2                	cmp    %eax,%edx
c010084e:	7c 46                	jl     c0100896 <debuginfo_eip+0x2b3>
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	89 c2                	mov    %eax,%edx
c0100855:	89 d0                	mov    %edx,%eax
c0100857:	01 c0                	add    %eax,%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	c1 e0 02             	shl    $0x2,%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	8b 00                	mov    (%eax),%eax
c0100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010086d:	29 d1                	sub    %edx,%ecx
c010086f:	89 ca                	mov    %ecx,%edx
c0100871:	39 d0                	cmp    %edx,%eax
c0100873:	73 21                	jae    c0100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 10                	mov    (%eax),%edx
c010088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088f:	01 c2                	add    %eax,%edx
c0100891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089c:	39 c2                	cmp    %eax,%edx
c010089e:	7d 4a                	jge    c01008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a3:	83 c0 01             	add    $0x1,%eax
c01008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008a9:	eb 18                	jmp    c01008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ae:	8b 40 14             	mov    0x14(%eax),%eax
c01008b1:	8d 50 01             	lea    0x1(%eax),%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	83 c0 01             	add    $0x1,%eax
c01008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7d 1d                	jge    c01008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008e6:	3c a0                	cmp    $0xa0,%al
c01008e8:	74 c1                	je     c01008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ef:	c9                   	leave  
c01008f0:	c3                   	ret    

c01008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f1:	55                   	push   %ebp
c01008f2:	89 e5                	mov    %esp,%ebp
c01008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008f7:	83 ec 0c             	sub    $0xc,%esp
c01008fa:	68 32 5f 10 c0       	push   $0xc0105f32
c01008ff:	e8 63 f9 ff ff       	call   c0100267 <cprintf>
c0100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100907:	83 ec 08             	sub    $0x8,%esp
c010090a:	68 2a 00 10 c0       	push   $0xc010002a
c010090f:	68 4b 5f 10 c0       	push   $0xc0105f4b
c0100914:	e8 4e f9 ff ff       	call   c0100267 <cprintf>
c0100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010091c:	83 ec 08             	sub    $0x8,%esp
c010091f:	68 2d 5e 10 c0       	push   $0xc0105e2d
c0100924:	68 63 5f 10 c0       	push   $0xc0105f63
c0100929:	e8 39 f9 ff ff       	call   c0100267 <cprintf>
c010092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100931:	83 ec 08             	sub    $0x8,%esp
c0100934:	68 36 7a 11 c0       	push   $0xc0117a36
c0100939:	68 7b 5f 10 c0       	push   $0xc0105f7b
c010093e:	e8 24 f9 ff ff       	call   c0100267 <cprintf>
c0100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100946:	83 ec 08             	sub    $0x8,%esp
c0100949:	68 68 89 11 c0       	push   $0xc0118968
c010094e:	68 93 5f 10 c0       	push   $0xc0105f93
c0100953:	e8 0f f9 ff ff       	call   c0100267 <cprintf>
c0100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095b:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100960:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100965:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096a:	29 d0                	sub    %edx,%eax
c010096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100972:	85 c0                	test   %eax,%eax
c0100974:	0f 48 c2             	cmovs  %edx,%eax
c0100977:	c1 f8 0a             	sar    $0xa,%eax
c010097a:	83 ec 08             	sub    $0x8,%esp
c010097d:	50                   	push   %eax
c010097e:	68 ac 5f 10 c0       	push   $0xc0105fac
c0100983:	e8 df f8 ff ff       	call   c0100267 <cprintf>
c0100988:	83 c4 10             	add    $0x10,%esp
}
c010098b:	90                   	nop
c010098c:	c9                   	leave  
c010098d:	c3                   	ret    

c010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010098e:	55                   	push   %ebp
c010098f:	89 e5                	mov    %esp,%ebp
c0100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100997:	83 ec 08             	sub    $0x8,%esp
c010099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010099d:	50                   	push   %eax
c010099e:	ff 75 08             	pushl  0x8(%ebp)
c01009a1:	e8 3d fc ff ff       	call   c01005e3 <debuginfo_eip>
c01009a6:	83 c4 10             	add    $0x10,%esp
c01009a9:	85 c0                	test   %eax,%eax
c01009ab:	74 15                	je     c01009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ad:	83 ec 08             	sub    $0x8,%esp
c01009b0:	ff 75 08             	pushl  0x8(%ebp)
c01009b3:	68 d6 5f 10 c0       	push   $0xc0105fd6
c01009b8:	e8 aa f8 ff ff       	call   c0100267 <cprintf>
c01009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c0:	eb 65                	jmp    c0100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009c9:	eb 1c                	jmp    c01009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	0f b6 00             	movzbl (%eax),%eax
c01009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009df:	01 ca                	add    %ecx,%edx
c01009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009ed:	7f dc                	jg     c01009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	01 d0                	add    %edx,%eax
c01009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c01009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a00:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a03:	89 d1                	mov    %edx,%ecx
c0100a05:	29 c1                	sub    %eax,%ecx
c0100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a0d:	83 ec 0c             	sub    $0xc,%esp
c0100a10:	51                   	push   %ecx
c0100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a17:	51                   	push   %ecx
c0100a18:	52                   	push   %edx
c0100a19:	50                   	push   %eax
c0100a1a:	68 f2 5f 10 c0       	push   $0xc0105ff2
c0100a1f:	e8 43 f8 ff ff       	call   c0100267 <cprintf>
c0100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a27:	90                   	nop
c0100a28:	c9                   	leave  
c0100a29:	c3                   	ret    

c0100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2a:	55                   	push   %ebp
c0100a2b:	89 e5                	mov    %esp,%ebp
c0100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a30:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a39:	c9                   	leave  
c0100a3a:	c3                   	ret    

c0100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3b:	55                   	push   %ebp
c0100a3c:	89 e5                	mov    %esp,%ebp
c0100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a41:	89 e8                	mov    %ebp,%eax
c0100a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp, eip;
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
c0100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    eip = read_eip();
c0100a4c:	e8 d9 ff ff ff       	call   c0100a2a <read_eip>
c0100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
c0100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a5b:	e9 85 00 00 00       	jmp    c0100ae5 <print_stackframe+0xaa>
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
c0100a60:	83 ec 04             	sub    $0x4,%esp
c0100a63:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a66:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a69:	68 04 60 10 c0       	push   $0xc0106004
c0100a6e:	e8 f4 f7 ff ff       	call   c0100267 <cprintf>
c0100a73:	83 c4 10             	add    $0x10,%esp
        
        for( i = 0; i < 4; i++ ) 
c0100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a7d:	eb 27                	jmp    c0100aa6 <print_stackframe+0x6b>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
c0100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a82:	c1 e0 02             	shl    $0x2,%eax
c0100a85:	89 c2                	mov    %eax,%edx
c0100a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8a:	01 d0                	add    %edx,%eax
c0100a8c:	83 c0 08             	add    $0x8,%eax
c0100a8f:	8b 00                	mov    (%eax),%eax
c0100a91:	83 ec 08             	sub    $0x8,%esp
c0100a94:	50                   	push   %eax
c0100a95:	68 25 60 10 c0       	push   $0xc0106025
c0100a9a:	e8 c8 f7 ff ff       	call   c0100267 <cprintf>
c0100a9f:	83 c4 10             	add    $0x10,%esp
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
        
        for( i = 0; i < 4; i++ ) 
c0100aa2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aa6:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100aaa:	7e d3                	jle    c0100a7f <print_stackframe+0x44>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
        
        cprintf( "\n" );
c0100aac:	83 ec 0c             	sub    $0xc,%esp
c0100aaf:	68 2d 60 10 c0       	push   $0xc010602d
c0100ab4:	e8 ae f7 ff ff       	call   c0100267 <cprintf>
c0100ab9:	83 c4 10             	add    $0x10,%esp
        print_debuginfo( eip - 1 );
c0100abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100abf:	83 e8 01             	sub    $0x1,%eax
c0100ac2:	83 ec 0c             	sub    $0xc,%esp
c0100ac5:	50                   	push   %eax
c0100ac6:	e8 c3 fe ff ff       	call   c010098e <print_debuginfo>
c0100acb:	83 c4 10             	add    $0x10,%esp
        eip = *( ( uint32_t * )( ebp + 4 ) );
c0100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad1:	83 c0 04             	add    $0x4,%eax
c0100ad4:	8b 00                	mov    (%eax),%eax
c0100ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *( ( uint32_t * )( ebp ) );
c0100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100adc:	8b 00                	mov    (%eax),%eax
c0100ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
    eip = read_eip();
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
c0100ae1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ae9:	74 0a                	je     c0100af5 <print_stackframe+0xba>
c0100aeb:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100aef:	0f 8e 6b ff ff ff    	jle    c0100a60 <print_stackframe+0x25>
        cprintf( "\n" );
        print_debuginfo( eip - 1 );
        eip = *( ( uint32_t * )( ebp + 4 ) );
        ebp = *( ( uint32_t * )( ebp ) );
    }        
}
c0100af5:	90                   	nop
c0100af6:	c9                   	leave  
c0100af7:	c3                   	ret    

c0100af8 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100af8:	55                   	push   %ebp
c0100af9:	89 e5                	mov    %esp,%ebp
c0100afb:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b05:	eb 0c                	jmp    c0100b13 <parse+0x1b>
            *buf ++ = '\0';
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b0d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b10:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b16:	0f b6 00             	movzbl (%eax),%eax
c0100b19:	84 c0                	test   %al,%al
c0100b1b:	74 1e                	je     c0100b3b <parse+0x43>
c0100b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b20:	0f b6 00             	movzbl (%eax),%eax
c0100b23:	0f be c0             	movsbl %al,%eax
c0100b26:	83 ec 08             	sub    $0x8,%esp
c0100b29:	50                   	push   %eax
c0100b2a:	68 b0 60 10 c0       	push   $0xc01060b0
c0100b2f:	e8 a3 49 00 00       	call   c01054d7 <strchr>
c0100b34:	83 c4 10             	add    $0x10,%esp
c0100b37:	85 c0                	test   %eax,%eax
c0100b39:	75 cc                	jne    c0100b07 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3e:	0f b6 00             	movzbl (%eax),%eax
c0100b41:	84 c0                	test   %al,%al
c0100b43:	74 69                	je     c0100bae <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b45:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b49:	75 12                	jne    c0100b5d <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b4b:	83 ec 08             	sub    $0x8,%esp
c0100b4e:	6a 10                	push   $0x10
c0100b50:	68 b5 60 10 c0       	push   $0xc01060b5
c0100b55:	e8 0d f7 ff ff       	call   c0100267 <cprintf>
c0100b5a:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b60:	8d 50 01             	lea    0x1(%eax),%edx
c0100b63:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b70:	01 c2                	add    %eax,%edx
c0100b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b75:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b77:	eb 04                	jmp    c0100b7d <parse+0x85>
            buf ++;
c0100b79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b80:	0f b6 00             	movzbl (%eax),%eax
c0100b83:	84 c0                	test   %al,%al
c0100b85:	0f 84 7a ff ff ff    	je     c0100b05 <parse+0xd>
c0100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8e:	0f b6 00             	movzbl (%eax),%eax
c0100b91:	0f be c0             	movsbl %al,%eax
c0100b94:	83 ec 08             	sub    $0x8,%esp
c0100b97:	50                   	push   %eax
c0100b98:	68 b0 60 10 c0       	push   $0xc01060b0
c0100b9d:	e8 35 49 00 00       	call   c01054d7 <strchr>
c0100ba2:	83 c4 10             	add    $0x10,%esp
c0100ba5:	85 c0                	test   %eax,%eax
c0100ba7:	74 d0                	je     c0100b79 <parse+0x81>
            buf ++;
        }
    }
c0100ba9:	e9 57 ff ff ff       	jmp    c0100b05 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bae:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bb2:	c9                   	leave  
c0100bb3:	c3                   	ret    

c0100bb4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bb4:	55                   	push   %ebp
c0100bb5:	89 e5                	mov    %esp,%ebp
c0100bb7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bba:	83 ec 08             	sub    $0x8,%esp
c0100bbd:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc0:	50                   	push   %eax
c0100bc1:	ff 75 08             	pushl  0x8(%ebp)
c0100bc4:	e8 2f ff ff ff       	call   c0100af8 <parse>
c0100bc9:	83 c4 10             	add    $0x10,%esp
c0100bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bd3:	75 0a                	jne    c0100bdf <runcmd+0x2b>
        return 0;
c0100bd5:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bda:	e9 83 00 00 00       	jmp    c0100c62 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100be6:	eb 59                	jmp    c0100c41 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100be8:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bee:	89 d0                	mov    %edx,%eax
c0100bf0:	01 c0                	add    %eax,%eax
c0100bf2:	01 d0                	add    %edx,%eax
c0100bf4:	c1 e0 02             	shl    $0x2,%eax
c0100bf7:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bfc:	8b 00                	mov    (%eax),%eax
c0100bfe:	83 ec 08             	sub    $0x8,%esp
c0100c01:	51                   	push   %ecx
c0100c02:	50                   	push   %eax
c0100c03:	e8 2f 48 00 00       	call   c0105437 <strcmp>
c0100c08:	83 c4 10             	add    $0x10,%esp
c0100c0b:	85 c0                	test   %eax,%eax
c0100c0d:	75 2e                	jne    c0100c3d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c12:	89 d0                	mov    %edx,%eax
c0100c14:	01 c0                	add    %eax,%eax
c0100c16:	01 d0                	add    %edx,%eax
c0100c18:	c1 e0 02             	shl    $0x2,%eax
c0100c1b:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c20:	8b 10                	mov    (%eax),%edx
c0100c22:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c25:	83 c0 04             	add    $0x4,%eax
c0100c28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c2b:	83 e9 01             	sub    $0x1,%ecx
c0100c2e:	83 ec 04             	sub    $0x4,%esp
c0100c31:	ff 75 0c             	pushl  0xc(%ebp)
c0100c34:	50                   	push   %eax
c0100c35:	51                   	push   %ecx
c0100c36:	ff d2                	call   *%edx
c0100c38:	83 c4 10             	add    $0x10,%esp
c0100c3b:	eb 25                	jmp    c0100c62 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c44:	83 f8 02             	cmp    $0x2,%eax
c0100c47:	76 9f                	jbe    c0100be8 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c49:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c4c:	83 ec 08             	sub    $0x8,%esp
c0100c4f:	50                   	push   %eax
c0100c50:	68 d3 60 10 c0       	push   $0xc01060d3
c0100c55:	e8 0d f6 ff ff       	call   c0100267 <cprintf>
c0100c5a:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c62:	c9                   	leave  
c0100c63:	c3                   	ret    

c0100c64 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c64:	55                   	push   %ebp
c0100c65:	89 e5                	mov    %esp,%ebp
c0100c67:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c6a:	83 ec 0c             	sub    $0xc,%esp
c0100c6d:	68 ec 60 10 c0       	push   $0xc01060ec
c0100c72:	e8 f0 f5 ff ff       	call   c0100267 <cprintf>
c0100c77:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c7a:	83 ec 0c             	sub    $0xc,%esp
c0100c7d:	68 14 61 10 c0       	push   $0xc0106114
c0100c82:	e8 e0 f5 ff ff       	call   c0100267 <cprintf>
c0100c87:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c8e:	74 0e                	je     c0100c9e <kmonitor+0x3a>
        print_trapframe(tf);
c0100c90:	83 ec 0c             	sub    $0xc,%esp
c0100c93:	ff 75 08             	pushl  0x8(%ebp)
c0100c96:	e8 9e 0d 00 00       	call   c0101a39 <print_trapframe>
c0100c9b:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c9e:	83 ec 0c             	sub    $0xc,%esp
c0100ca1:	68 39 61 10 c0       	push   $0xc0106139
c0100ca6:	e8 60 f6 ff ff       	call   c010030b <readline>
c0100cab:	83 c4 10             	add    $0x10,%esp
c0100cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cb5:	74 e7                	je     c0100c9e <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cb7:	83 ec 08             	sub    $0x8,%esp
c0100cba:	ff 75 08             	pushl  0x8(%ebp)
c0100cbd:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cc0:	e8 ef fe ff ff       	call   c0100bb4 <runcmd>
c0100cc5:	83 c4 10             	add    $0x10,%esp
c0100cc8:	85 c0                	test   %eax,%eax
c0100cca:	78 02                	js     c0100cce <kmonitor+0x6a>
                break;
            }
        }
    }
c0100ccc:	eb d0                	jmp    c0100c9e <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cce:	90                   	nop
            }
        }
    }
}
c0100ccf:	90                   	nop
c0100cd0:	c9                   	leave  
c0100cd1:	c3                   	ret    

c0100cd2 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cd2:	55                   	push   %ebp
c0100cd3:	89 e5                	mov    %esp,%ebp
c0100cd5:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cdf:	eb 3c                	jmp    c0100d1d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ce4:	89 d0                	mov    %edx,%eax
c0100ce6:	01 c0                	add    %eax,%eax
c0100ce8:	01 d0                	add    %edx,%eax
c0100cea:	c1 e0 02             	shl    $0x2,%eax
c0100ced:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100cf2:	8b 08                	mov    (%eax),%ecx
c0100cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cf7:	89 d0                	mov    %edx,%eax
c0100cf9:	01 c0                	add    %eax,%eax
c0100cfb:	01 d0                	add    %edx,%eax
c0100cfd:	c1 e0 02             	shl    $0x2,%eax
c0100d00:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d05:	8b 00                	mov    (%eax),%eax
c0100d07:	83 ec 04             	sub    $0x4,%esp
c0100d0a:	51                   	push   %ecx
c0100d0b:	50                   	push   %eax
c0100d0c:	68 3d 61 10 c0       	push   $0xc010613d
c0100d11:	e8 51 f5 ff ff       	call   c0100267 <cprintf>
c0100d16:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d20:	83 f8 02             	cmp    $0x2,%eax
c0100d23:	76 bc                	jbe    c0100ce1 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d2a:	c9                   	leave  
c0100d2b:	c3                   	ret    

c0100d2c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d2c:	55                   	push   %ebp
c0100d2d:	89 e5                	mov    %esp,%ebp
c0100d2f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d32:	e8 ba fb ff ff       	call   c01008f1 <print_kerninfo>
    return 0;
c0100d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d3c:	c9                   	leave  
c0100d3d:	c3                   	ret    

c0100d3e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d3e:	55                   	push   %ebp
c0100d3f:	89 e5                	mov    %esp,%ebp
c0100d41:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d44:	e8 f2 fc ff ff       	call   c0100a3b <print_stackframe>
    return 0;
c0100d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d4e:	c9                   	leave  
c0100d4f:	c3                   	ret    

c0100d50 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d50:	55                   	push   %ebp
c0100d51:	89 e5                	mov    %esp,%ebp
c0100d53:	83 ec 18             	sub    $0x18,%esp
c0100d56:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d5c:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d60:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d68:	ee                   	out    %al,(%dx)
c0100d69:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d6f:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d73:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d77:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d7b:	ee                   	out    %al,(%dx)
c0100d7c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d82:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d8e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d8f:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d96:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d99:	83 ec 0c             	sub    $0xc,%esp
c0100d9c:	68 46 61 10 c0       	push   $0xc0106146
c0100da1:	e8 c1 f4 ff ff       	call   c0100267 <cprintf>
c0100da6:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100da9:	83 ec 0c             	sub    $0xc,%esp
c0100dac:	6a 00                	push   $0x0
c0100dae:	e8 3b 09 00 00       	call   c01016ee <pic_enable>
c0100db3:	83 c4 10             	add    $0x10,%esp
}
c0100db6:	90                   	nop
c0100db7:	c9                   	leave  
c0100db8:	c3                   	ret    

c0100db9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100db9:	55                   	push   %ebp
c0100dba:	89 e5                	mov    %esp,%ebp
c0100dbc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dbf:	9c                   	pushf  
c0100dc0:	58                   	pop    %eax
c0100dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dc7:	25 00 02 00 00       	and    $0x200,%eax
c0100dcc:	85 c0                	test   %eax,%eax
c0100dce:	74 0c                	je     c0100ddc <__intr_save+0x23>
        intr_disable();
c0100dd0:	e8 8a 0a 00 00       	call   c010185f <intr_disable>
        return 1;
c0100dd5:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dda:	eb 05                	jmp    c0100de1 <__intr_save+0x28>
    }
    return 0;
c0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100de3:	55                   	push   %ebp
c0100de4:	89 e5                	mov    %esp,%ebp
c0100de6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ded:	74 05                	je     c0100df4 <__intr_restore+0x11>
        intr_enable();
c0100def:	e8 64 0a 00 00       	call   c0101858 <intr_enable>
    }
}
c0100df4:	90                   	nop
c0100df5:	c9                   	leave  
c0100df6:	c3                   	ret    

c0100df7 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100df7:	55                   	push   %ebp
c0100df8:	89 e5                	mov    %esp,%ebp
c0100dfa:	83 ec 10             	sub    $0x10,%esp
c0100dfd:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e03:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e07:	89 c2                	mov    %eax,%edx
c0100e09:	ec                   	in     (%dx),%al
c0100e0a:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e0d:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e13:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e17:	89 c2                	mov    %eax,%edx
c0100e19:	ec                   	in     (%dx),%al
c0100e1a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e1d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e23:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e27:	89 c2                	mov    %eax,%edx
c0100e29:	ec                   	in     (%dx),%al
c0100e2a:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e2d:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e33:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e37:	89 c2                	mov    %eax,%edx
c0100e39:	ec                   	in     (%dx),%al
c0100e3a:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e3d:	90                   	nop
c0100e3e:	c9                   	leave  
c0100e3f:	c3                   	ret    

c0100e40 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e40:	55                   	push   %ebp
c0100e41:	89 e5                	mov    %esp,%ebp
c0100e43:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e46:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e50:	0f b7 00             	movzwl (%eax),%eax
c0100e53:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e5a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e62:	0f b7 00             	movzwl (%eax),%eax
c0100e65:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e69:	74 12                	je     c0100e7d <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e6b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e72:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e79:	b4 03 
c0100e7b:	eb 13                	jmp    c0100e90 <cga_init+0x50>
    } else {
        *cp = was;
c0100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e80:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e84:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e87:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e8e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e90:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e97:	0f b7 c0             	movzwl %ax,%eax
c0100e9a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100e9e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea2:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100ea6:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100eaa:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eab:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eb2:	83 c0 01             	add    $0x1,%eax
c0100eb5:	0f b7 c0             	movzwl %ax,%eax
c0100eb8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ebc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ec0:	89 c2                	mov    %eax,%edx
c0100ec2:	ec                   	in     (%dx),%al
c0100ec3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ec6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100eca:	0f b6 c0             	movzbl %al,%eax
c0100ecd:	c1 e0 08             	shl    $0x8,%eax
c0100ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ed3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eda:	0f b7 c0             	movzwl %ax,%eax
c0100edd:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ee1:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100ee9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100eed:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100eee:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef5:	83 c0 01             	add    $0x1,%eax
c0100ef8:	0f b7 c0             	movzwl %ax,%eax
c0100efb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eff:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f03:	89 c2                	mov    %eax,%edx
c0100f05:	ec                   	in     (%dx),%al
c0100f06:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0d:	0f b6 c0             	movzbl %al,%eax
c0100f10:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f16:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f1e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f24:	90                   	nop
c0100f25:	c9                   	leave  
c0100f26:	c3                   	ret    

c0100f27 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f27:	55                   	push   %ebp
c0100f28:	89 e5                	mov    %esp,%ebp
c0100f2a:	83 ec 28             	sub    $0x28,%esp
c0100f2d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f33:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f37:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f3b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f3f:	ee                   	out    %al,(%dx)
c0100f40:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f46:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f4a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f4e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f52:	ee                   	out    %al,(%dx)
c0100f53:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f59:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f5d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f61:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f65:	ee                   	out    %al,(%dx)
c0100f66:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f6c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f70:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f74:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f78:	ee                   	out    %al,(%dx)
c0100f79:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f7f:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f83:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f87:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8b:	ee                   	out    %al,(%dx)
c0100f8c:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f92:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f96:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100f9a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100f9e:	ee                   	out    %al,(%dx)
c0100f9f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa5:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fa9:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb1:	ee                   	out    %al,(%dx)
c0100fb2:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fb8:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fbc:	89 c2                	mov    %eax,%edx
c0100fbe:	ec                   	in     (%dx),%al
c0100fbf:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fc2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fc6:	3c ff                	cmp    $0xff,%al
c0100fc8:	0f 95 c0             	setne  %al
c0100fcb:	0f b6 c0             	movzbl %al,%eax
c0100fce:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fd3:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fdd:	89 c2                	mov    %eax,%edx
c0100fdf:	ec                   	in     (%dx),%al
c0100fe0:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100fe3:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100fe9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100fed:	89 c2                	mov    %eax,%edx
c0100fef:	ec                   	in     (%dx),%al
c0100ff0:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100ff3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100ff8:	85 c0                	test   %eax,%eax
c0100ffa:	74 0d                	je     c0101009 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0100ffc:	83 ec 0c             	sub    $0xc,%esp
c0100fff:	6a 04                	push   $0x4
c0101001:	e8 e8 06 00 00       	call   c01016ee <pic_enable>
c0101006:	83 c4 10             	add    $0x10,%esp
    }
}
c0101009:	90                   	nop
c010100a:	c9                   	leave  
c010100b:	c3                   	ret    

c010100c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010100c:	55                   	push   %ebp
c010100d:	89 e5                	mov    %esp,%ebp
c010100f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101019:	eb 09                	jmp    c0101024 <lpt_putc_sub+0x18>
        delay();
c010101b:	e8 d7 fd ff ff       	call   c0100df7 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101020:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101024:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c010102a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010102e:	89 c2                	mov    %eax,%edx
c0101030:	ec                   	in     (%dx),%al
c0101031:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101034:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101038:	84 c0                	test   %al,%al
c010103a:	78 09                	js     c0101045 <lpt_putc_sub+0x39>
c010103c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101043:	7e d6                	jle    c010101b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101045:	8b 45 08             	mov    0x8(%ebp),%eax
c0101048:	0f b6 c0             	movzbl %al,%eax
c010104b:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101051:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101054:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0101058:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010105c:	ee                   	out    %al,(%dx)
c010105d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101063:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101067:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010106b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010106f:	ee                   	out    %al,(%dx)
c0101070:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0101076:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010107a:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c010107e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101082:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101083:	90                   	nop
c0101084:	c9                   	leave  
c0101085:	c3                   	ret    

c0101086 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101086:	55                   	push   %ebp
c0101087:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101089:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010108d:	74 0d                	je     c010109c <lpt_putc+0x16>
        lpt_putc_sub(c);
c010108f:	ff 75 08             	pushl  0x8(%ebp)
c0101092:	e8 75 ff ff ff       	call   c010100c <lpt_putc_sub>
c0101097:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010109a:	eb 1e                	jmp    c01010ba <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c010109c:	6a 08                	push   $0x8
c010109e:	e8 69 ff ff ff       	call   c010100c <lpt_putc_sub>
c01010a3:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010a6:	6a 20                	push   $0x20
c01010a8:	e8 5f ff ff ff       	call   c010100c <lpt_putc_sub>
c01010ad:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010b0:	6a 08                	push   $0x8
c01010b2:	e8 55 ff ff ff       	call   c010100c <lpt_putc_sub>
c01010b7:	83 c4 04             	add    $0x4,%esp
    }
}
c01010ba:	90                   	nop
c01010bb:	c9                   	leave  
c01010bc:	c3                   	ret    

c01010bd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010bd:	55                   	push   %ebp
c01010be:	89 e5                	mov    %esp,%ebp
c01010c0:	53                   	push   %ebx
c01010c1:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c7:	b0 00                	mov    $0x0,%al
c01010c9:	85 c0                	test   %eax,%eax
c01010cb:	75 07                	jne    c01010d4 <cga_putc+0x17>
        c |= 0x0700;
c01010cd:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d7:	0f b6 c0             	movzbl %al,%eax
c01010da:	83 f8 0a             	cmp    $0xa,%eax
c01010dd:	74 4e                	je     c010112d <cga_putc+0x70>
c01010df:	83 f8 0d             	cmp    $0xd,%eax
c01010e2:	74 59                	je     c010113d <cga_putc+0x80>
c01010e4:	83 f8 08             	cmp    $0x8,%eax
c01010e7:	0f 85 8a 00 00 00    	jne    c0101177 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010ed:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010f4:	66 85 c0             	test   %ax,%ax
c01010f7:	0f 84 a0 00 00 00    	je     c010119d <cga_putc+0xe0>
            crt_pos --;
c01010fd:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101104:	83 e8 01             	sub    $0x1,%eax
c0101107:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010110d:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101112:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101119:	0f b7 d2             	movzwl %dx,%edx
c010111c:	01 d2                	add    %edx,%edx
c010111e:	01 d0                	add    %edx,%eax
c0101120:	8b 55 08             	mov    0x8(%ebp),%edx
c0101123:	b2 00                	mov    $0x0,%dl
c0101125:	83 ca 20             	or     $0x20,%edx
c0101128:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010112b:	eb 70                	jmp    c010119d <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c010112d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101134:	83 c0 50             	add    $0x50,%eax
c0101137:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010113d:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101144:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010114b:	0f b7 c1             	movzwl %cx,%eax
c010114e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101154:	c1 e8 10             	shr    $0x10,%eax
c0101157:	89 c2                	mov    %eax,%edx
c0101159:	66 c1 ea 06          	shr    $0x6,%dx
c010115d:	89 d0                	mov    %edx,%eax
c010115f:	c1 e0 02             	shl    $0x2,%eax
c0101162:	01 d0                	add    %edx,%eax
c0101164:	c1 e0 04             	shl    $0x4,%eax
c0101167:	29 c1                	sub    %eax,%ecx
c0101169:	89 ca                	mov    %ecx,%edx
c010116b:	89 d8                	mov    %ebx,%eax
c010116d:	29 d0                	sub    %edx,%eax
c010116f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101175:	eb 27                	jmp    c010119e <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101177:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c010117d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101184:	8d 50 01             	lea    0x1(%eax),%edx
c0101187:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c010118e:	0f b7 c0             	movzwl %ax,%eax
c0101191:	01 c0                	add    %eax,%eax
c0101193:	01 c8                	add    %ecx,%eax
c0101195:	8b 55 08             	mov    0x8(%ebp),%edx
c0101198:	66 89 10             	mov    %dx,(%eax)
        break;
c010119b:	eb 01                	jmp    c010119e <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c010119d:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010119e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011a5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011a9:	76 59                	jbe    c0101204 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ab:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011b0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011b6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011bb:	83 ec 04             	sub    $0x4,%esp
c01011be:	68 00 0f 00 00       	push   $0xf00
c01011c3:	52                   	push   %edx
c01011c4:	50                   	push   %eax
c01011c5:	e8 0c 45 00 00       	call   c01056d6 <memmove>
c01011ca:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011cd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011d4:	eb 15                	jmp    c01011eb <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011de:	01 d2                	add    %edx,%edx
c01011e0:	01 d0                	add    %edx,%eax
c01011e2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011eb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011f2:	7e e2                	jle    c01011d6 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c01011f4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011fb:	83 e8 50             	sub    $0x50,%eax
c01011fe:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101204:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010120b:	0f b7 c0             	movzwl %ax,%eax
c010120e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101212:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101216:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c010121a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010121e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010121f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101226:	66 c1 e8 08          	shr    $0x8,%ax
c010122a:	0f b6 c0             	movzbl %al,%eax
c010122d:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101234:	83 c2 01             	add    $0x1,%edx
c0101237:	0f b7 d2             	movzwl %dx,%edx
c010123a:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c010123e:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101241:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101245:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101249:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010124a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101251:	0f b7 c0             	movzwl %ax,%eax
c0101254:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101258:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c010125c:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101260:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101264:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101265:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010126c:	0f b6 c0             	movzbl %al,%eax
c010126f:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101276:	83 c2 01             	add    $0x1,%edx
c0101279:	0f b7 d2             	movzwl %dx,%edx
c010127c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101280:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101283:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101287:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c010128b:	ee                   	out    %al,(%dx)
}
c010128c:	90                   	nop
c010128d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101290:	c9                   	leave  
c0101291:	c3                   	ret    

c0101292 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101292:	55                   	push   %ebp
c0101293:	89 e5                	mov    %esp,%ebp
c0101295:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010129f:	eb 09                	jmp    c01012aa <serial_putc_sub+0x18>
        delay();
c01012a1:	e8 51 fb ff ff       	call   c0100df7 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012aa:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012b0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012b4:	89 c2                	mov    %eax,%edx
c01012b6:	ec                   	in     (%dx),%al
c01012b7:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012ba:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012be:	0f b6 c0             	movzbl %al,%eax
c01012c1:	83 e0 20             	and    $0x20,%eax
c01012c4:	85 c0                	test   %eax,%eax
c01012c6:	75 09                	jne    c01012d1 <serial_putc_sub+0x3f>
c01012c8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012cf:	7e d0                	jle    c01012a1 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	0f b6 c0             	movzbl %al,%eax
c01012d7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012dd:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012e0:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012e8:	ee                   	out    %al,(%dx)
}
c01012e9:	90                   	nop
c01012ea:	c9                   	leave  
c01012eb:	c3                   	ret    

c01012ec <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012ec:	55                   	push   %ebp
c01012ed:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012ef:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012f3:	74 0d                	je     c0101302 <serial_putc+0x16>
        serial_putc_sub(c);
c01012f5:	ff 75 08             	pushl  0x8(%ebp)
c01012f8:	e8 95 ff ff ff       	call   c0101292 <serial_putc_sub>
c01012fd:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101300:	eb 1e                	jmp    c0101320 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101302:	6a 08                	push   $0x8
c0101304:	e8 89 ff ff ff       	call   c0101292 <serial_putc_sub>
c0101309:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c010130c:	6a 20                	push   $0x20
c010130e:	e8 7f ff ff ff       	call   c0101292 <serial_putc_sub>
c0101313:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101316:	6a 08                	push   $0x8
c0101318:	e8 75 ff ff ff       	call   c0101292 <serial_putc_sub>
c010131d:	83 c4 04             	add    $0x4,%esp
    }
}
c0101320:	90                   	nop
c0101321:	c9                   	leave  
c0101322:	c3                   	ret    

c0101323 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101323:	55                   	push   %ebp
c0101324:	89 e5                	mov    %esp,%ebp
c0101326:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101329:	eb 33                	jmp    c010135e <cons_intr+0x3b>
        if (c != 0) {
c010132b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010132f:	74 2d                	je     c010135e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101331:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101336:	8d 50 01             	lea    0x1(%eax),%edx
c0101339:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101342:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101348:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010134d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101352:	75 0a                	jne    c010135e <cons_intr+0x3b>
                cons.wpos = 0;
c0101354:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010135b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010135e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101361:	ff d0                	call   *%eax
c0101363:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101366:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010136a:	75 bf                	jne    c010132b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010136c:	90                   	nop
c010136d:	c9                   	leave  
c010136e:	c3                   	ret    

c010136f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010136f:	55                   	push   %ebp
c0101370:	89 e5                	mov    %esp,%ebp
c0101372:	83 ec 10             	sub    $0x10,%esp
c0101375:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010137b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c010137f:	89 c2                	mov    %eax,%edx
c0101381:	ec                   	in     (%dx),%al
c0101382:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101385:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101389:	0f b6 c0             	movzbl %al,%eax
c010138c:	83 e0 01             	and    $0x1,%eax
c010138f:	85 c0                	test   %eax,%eax
c0101391:	75 07                	jne    c010139a <serial_proc_data+0x2b>
        return -1;
c0101393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101398:	eb 2a                	jmp    c01013c4 <serial_proc_data+0x55>
c010139a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a4:	89 c2                	mov    %eax,%edx
c01013a6:	ec                   	in     (%dx),%al
c01013a7:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013aa:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ae:	0f b6 c0             	movzbl %al,%eax
c01013b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013b4:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013b8:	75 07                	jne    c01013c1 <serial_proc_data+0x52>
        c = '\b';
c01013ba:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013c4:	c9                   	leave  
c01013c5:	c3                   	ret    

c01013c6 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013c6:	55                   	push   %ebp
c01013c7:	89 e5                	mov    %esp,%ebp
c01013c9:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013cc:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013d1:	85 c0                	test   %eax,%eax
c01013d3:	74 10                	je     c01013e5 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013d5:	83 ec 0c             	sub    $0xc,%esp
c01013d8:	68 6f 13 10 c0       	push   $0xc010136f
c01013dd:	e8 41 ff ff ff       	call   c0101323 <cons_intr>
c01013e2:	83 c4 10             	add    $0x10,%esp
    }
}
c01013e5:	90                   	nop
c01013e6:	c9                   	leave  
c01013e7:	c3                   	ret    

c01013e8 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013e8:	55                   	push   %ebp
c01013e9:	89 e5                	mov    %esp,%ebp
c01013eb:	83 ec 18             	sub    $0x18,%esp
c01013ee:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013f8:	89 c2                	mov    %eax,%edx
c01013fa:	ec                   	in     (%dx),%al
c01013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01013fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101402:	0f b6 c0             	movzbl %al,%eax
c0101405:	83 e0 01             	and    $0x1,%eax
c0101408:	85 c0                	test   %eax,%eax
c010140a:	75 0a                	jne    c0101416 <kbd_proc_data+0x2e>
        return -1;
c010140c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101411:	e9 5d 01 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
c0101416:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101420:	89 c2                	mov    %eax,%edx
c0101422:	ec                   	in     (%dx),%al
c0101423:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101426:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c010142a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010142d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101431:	75 17                	jne    c010144a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101433:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101438:	83 c8 40             	or     $0x40,%eax
c010143b:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101440:	b8 00 00 00 00       	mov    $0x0,%eax
c0101445:	e9 29 01 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c010144a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010144e:	84 c0                	test   %al,%al
c0101450:	79 47                	jns    c0101499 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101452:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101457:	83 e0 40             	and    $0x40,%eax
c010145a:	85 c0                	test   %eax,%eax
c010145c:	75 09                	jne    c0101467 <kbd_proc_data+0x7f>
c010145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101462:	83 e0 7f             	and    $0x7f,%eax
c0101465:	eb 04                	jmp    c010146b <kbd_proc_data+0x83>
c0101467:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010146b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010146e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101472:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101479:	83 c8 40             	or     $0x40,%eax
c010147c:	0f b6 c0             	movzbl %al,%eax
c010147f:	f7 d0                	not    %eax
c0101481:	89 c2                	mov    %eax,%edx
c0101483:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101488:	21 d0                	and    %edx,%eax
c010148a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010148f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101494:	e9 da 00 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101499:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010149e:	83 e0 40             	and    $0x40,%eax
c01014a1:	85 c0                	test   %eax,%eax
c01014a3:	74 11                	je     c01014b6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014a5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014a9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ae:	83 e0 bf             	and    $0xffffffbf,%eax
c01014b1:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ba:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014c1:	0f b6 d0             	movzbl %al,%edx
c01014c4:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c9:	09 d0                	or     %edx,%eax
c01014cb:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d4:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014db:	0f b6 d0             	movzbl %al,%edx
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	31 d0                	xor    %edx,%eax
c01014e5:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014ea:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ef:	83 e0 03             	and    $0x3,%eax
c01014f2:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c01014f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fd:	01 d0                	add    %edx,%eax
c01014ff:	0f b6 00             	movzbl (%eax),%eax
c0101502:	0f b6 c0             	movzbl %al,%eax
c0101505:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101508:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010150d:	83 e0 08             	and    $0x8,%eax
c0101510:	85 c0                	test   %eax,%eax
c0101512:	74 22                	je     c0101536 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101514:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101518:	7e 0c                	jle    c0101526 <kbd_proc_data+0x13e>
c010151a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010151e:	7f 06                	jg     c0101526 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101520:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101524:	eb 10                	jmp    c0101536 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101526:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010152a:	7e 0a                	jle    c0101536 <kbd_proc_data+0x14e>
c010152c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101530:	7f 04                	jg     c0101536 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101532:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	f7 d0                	not    %eax
c010153d:	83 e0 06             	and    $0x6,%eax
c0101540:	85 c0                	test   %eax,%eax
c0101542:	75 2c                	jne    c0101570 <kbd_proc_data+0x188>
c0101544:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010154b:	75 23                	jne    c0101570 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c010154d:	83 ec 0c             	sub    $0xc,%esp
c0101550:	68 61 61 10 c0       	push   $0xc0106161
c0101555:	e8 0d ed ff ff       	call   c0100267 <cprintf>
c010155a:	83 c4 10             	add    $0x10,%esp
c010155d:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101563:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101567:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010156b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010156f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101570:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101573:	c9                   	leave  
c0101574:	c3                   	ret    

c0101575 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101575:	55                   	push   %ebp
c0101576:	89 e5                	mov    %esp,%ebp
c0101578:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c010157b:	83 ec 0c             	sub    $0xc,%esp
c010157e:	68 e8 13 10 c0       	push   $0xc01013e8
c0101583:	e8 9b fd ff ff       	call   c0101323 <cons_intr>
c0101588:	83 c4 10             	add    $0x10,%esp
}
c010158b:	90                   	nop
c010158c:	c9                   	leave  
c010158d:	c3                   	ret    

c010158e <kbd_init>:

static void
kbd_init(void) {
c010158e:	55                   	push   %ebp
c010158f:	89 e5                	mov    %esp,%ebp
c0101591:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101594:	e8 dc ff ff ff       	call   c0101575 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101599:	83 ec 0c             	sub    $0xc,%esp
c010159c:	6a 01                	push   $0x1
c010159e:	e8 4b 01 00 00       	call   c01016ee <pic_enable>
c01015a3:	83 c4 10             	add    $0x10,%esp
}
c01015a6:	90                   	nop
c01015a7:	c9                   	leave  
c01015a8:	c3                   	ret    

c01015a9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015a9:	55                   	push   %ebp
c01015aa:	89 e5                	mov    %esp,%ebp
c01015ac:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015af:	e8 8c f8 ff ff       	call   c0100e40 <cga_init>
    serial_init();
c01015b4:	e8 6e f9 ff ff       	call   c0100f27 <serial_init>
    kbd_init();
c01015b9:	e8 d0 ff ff ff       	call   c010158e <kbd_init>
    if (!serial_exists) {
c01015be:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015c3:	85 c0                	test   %eax,%eax
c01015c5:	75 10                	jne    c01015d7 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015c7:	83 ec 0c             	sub    $0xc,%esp
c01015ca:	68 6d 61 10 c0       	push   $0xc010616d
c01015cf:	e8 93 ec ff ff       	call   c0100267 <cprintf>
c01015d4:	83 c4 10             	add    $0x10,%esp
    }
}
c01015d7:	90                   	nop
c01015d8:	c9                   	leave  
c01015d9:	c3                   	ret    

c01015da <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015da:	55                   	push   %ebp
c01015db:	89 e5                	mov    %esp,%ebp
c01015dd:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015e0:	e8 d4 f7 ff ff       	call   c0100db9 <__intr_save>
c01015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015e8:	83 ec 0c             	sub    $0xc,%esp
c01015eb:	ff 75 08             	pushl  0x8(%ebp)
c01015ee:	e8 93 fa ff ff       	call   c0101086 <lpt_putc>
c01015f3:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01015f6:	83 ec 0c             	sub    $0xc,%esp
c01015f9:	ff 75 08             	pushl  0x8(%ebp)
c01015fc:	e8 bc fa ff ff       	call   c01010bd <cga_putc>
c0101601:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101604:	83 ec 0c             	sub    $0xc,%esp
c0101607:	ff 75 08             	pushl  0x8(%ebp)
c010160a:	e8 dd fc ff ff       	call   c01012ec <serial_putc>
c010160f:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101612:	83 ec 0c             	sub    $0xc,%esp
c0101615:	ff 75 f4             	pushl  -0xc(%ebp)
c0101618:	e8 c6 f7 ff ff       	call   c0100de3 <__intr_restore>
c010161d:	83 c4 10             	add    $0x10,%esp
}
c0101620:	90                   	nop
c0101621:	c9                   	leave  
c0101622:	c3                   	ret    

c0101623 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101630:	e8 84 f7 ff ff       	call   c0100db9 <__intr_save>
c0101635:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101638:	e8 89 fd ff ff       	call   c01013c6 <serial_intr>
        kbd_intr();
c010163d:	e8 33 ff ff ff       	call   c0101575 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101642:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101648:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010164d:	39 c2                	cmp    %eax,%edx
c010164f:	74 31                	je     c0101682 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101651:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101656:	8d 50 01             	lea    0x1(%eax),%edx
c0101659:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010165f:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101666:	0f b6 c0             	movzbl %al,%eax
c0101669:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010166c:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101671:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101676:	75 0a                	jne    c0101682 <cons_getc+0x5f>
                cons.rpos = 0;
c0101678:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010167f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101682:	83 ec 0c             	sub    $0xc,%esp
c0101685:	ff 75 f0             	pushl  -0x10(%ebp)
c0101688:	e8 56 f7 ff ff       	call   c0100de3 <__intr_restore>
c010168d:	83 c4 10             	add    $0x10,%esp
    return c;
c0101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101693:	c9                   	leave  
c0101694:	c3                   	ret    

c0101695 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101695:	55                   	push   %ebp
c0101696:	89 e5                	mov    %esp,%ebp
c0101698:	83 ec 14             	sub    $0x14,%esp
c010169b:	8b 45 08             	mov    0x8(%ebp),%eax
c010169e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016a6:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016ac:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016b1:	85 c0                	test   %eax,%eax
c01016b3:	74 36                	je     c01016eb <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016b5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016b9:	0f b6 c0             	movzbl %al,%eax
c01016bc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016c2:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016c5:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016c9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016cd:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d2:	66 c1 e8 08          	shr    $0x8,%ax
c01016d6:	0f b6 c0             	movzbl %al,%eax
c01016d9:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016df:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016e2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016e6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016ea:	ee                   	out    %al,(%dx)
    }
}
c01016eb:	90                   	nop
c01016ec:	c9                   	leave  
c01016ed:	c3                   	ret    

c01016ee <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016ee:	55                   	push   %ebp
c01016ef:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f4:	ba 01 00 00 00       	mov    $0x1,%edx
c01016f9:	89 c1                	mov    %eax,%ecx
c01016fb:	d3 e2                	shl    %cl,%edx
c01016fd:	89 d0                	mov    %edx,%eax
c01016ff:	f7 d0                	not    %eax
c0101701:	89 c2                	mov    %eax,%edx
c0101703:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010170a:	21 d0                	and    %edx,%eax
c010170c:	0f b7 c0             	movzwl %ax,%eax
c010170f:	50                   	push   %eax
c0101710:	e8 80 ff ff ff       	call   c0101695 <pic_setmask>
c0101715:	83 c4 04             	add    $0x4,%esp
}
c0101718:	90                   	nop
c0101719:	c9                   	leave  
c010171a:	c3                   	ret    

c010171b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010171b:	55                   	push   %ebp
c010171c:	89 e5                	mov    %esp,%ebp
c010171e:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101721:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101728:	00 00 00 
c010172b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101731:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101735:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101739:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010173d:	ee                   	out    %al,(%dx)
c010173e:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101744:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101748:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010174c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101750:	ee                   	out    %al,(%dx)
c0101751:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101757:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c010175b:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010175f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101763:	ee                   	out    %al,(%dx)
c0101764:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c010176a:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c010176e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101772:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101776:	ee                   	out    %al,(%dx)
c0101777:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c010177d:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101781:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101785:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101789:	ee                   	out    %al,(%dx)
c010178a:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101790:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101794:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101798:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c010179c:	ee                   	out    %al,(%dx)
c010179d:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017a3:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017a7:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017ab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
c01017b0:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017b6:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017ba:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017be:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017c2:	ee                   	out    %al,(%dx)
c01017c3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017c9:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017cd:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017d5:	ee                   	out    %al,(%dx)
c01017d6:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017dc:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017e0:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017e4:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017e8:	ee                   	out    %al,(%dx)
c01017e9:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017ef:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01017f3:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017f7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fb:	ee                   	out    %al,(%dx)
c01017fc:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101802:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0101806:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010180a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010180e:	ee                   	out    %al,(%dx)
c010180f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101815:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101819:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c010181d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101821:	ee                   	out    %al,(%dx)
c0101822:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c0101828:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c010182c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101830:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101834:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101835:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010183c:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101840:	74 13                	je     c0101855 <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101842:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101849:	0f b7 c0             	movzwl %ax,%eax
c010184c:	50                   	push   %eax
c010184d:	e8 43 fe ff ff       	call   c0101695 <pic_setmask>
c0101852:	83 c4 04             	add    $0x4,%esp
    }
}
c0101855:	90                   	nop
c0101856:	c9                   	leave  
c0101857:	c3                   	ret    

c0101858 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101858:	55                   	push   %ebp
c0101859:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010185b:	fb                   	sti    
    sti();
}
c010185c:	90                   	nop
c010185d:	5d                   	pop    %ebp
c010185e:	c3                   	ret    

c010185f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010185f:	55                   	push   %ebp
c0101860:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101862:	fa                   	cli    
    cli();
}
c0101863:	90                   	nop
c0101864:	5d                   	pop    %ebp
c0101865:	c3                   	ret    

c0101866 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101866:	55                   	push   %ebp
c0101867:	89 e5                	mov    %esp,%ebp
c0101869:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010186c:	83 ec 08             	sub    $0x8,%esp
c010186f:	6a 64                	push   $0x64
c0101871:	68 a0 61 10 c0       	push   $0xc01061a0
c0101876:	e8 ec e9 ff ff       	call   c0100267 <cprintf>
c010187b:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010187e:	90                   	nop
c010187f:	c9                   	leave  
c0101880:	c3                   	ret    

c0101881 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101881:	55                   	push   %ebp
c0101882:	89 e5                	mov    %esp,%ebp
c0101884:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
c0101887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010188e:	e9 c3 00 00 00       	jmp    c0101956 <idt_init+0xd5>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
c0101893:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101896:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010189d:	89 c2                	mov    %eax,%edx
c010189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a2:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018a9:	c0 
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018b4:	c0 08 00 
c01018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ba:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018c1:	c0 
c01018c2:	83 e2 e0             	and    $0xffffffe0,%edx
c01018c5:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cf:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d6:	c0 
c01018d7:	83 e2 1f             	and    $0x1f,%edx
c01018da:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e4:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018eb:	c0 
c01018ec:	83 e2 f0             	and    $0xfffffff0,%edx
c01018ef:	83 ca 0e             	or     $0xe,%edx
c01018f2:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fc:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101903:	c0 
c0101904:	83 e2 ef             	and    $0xffffffef,%edx
c0101907:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101911:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101918:	c0 
c0101919:	83 e2 9f             	and    $0xffffff9f,%edx
c010191c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101926:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192d:	c0 
c010192e:	83 ca 80             	or     $0xffffff80,%edx
c0101931:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101938:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193b:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101942:	c1 e8 10             	shr    $0x10,%eax
c0101945:	89 c2                	mov    %eax,%edx
c0101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194a:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101951:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
c0101952:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101956:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010195d:	0f 8e 30 ff ff ff    	jle    c0101893 <idt_init+0x12>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
    }

    SETGATE( idt[ T_SWITCH_TOK ], 0, GD_KTEXT, __vectors[ T_SWITCH_TOK ], DPL_USER ); 
c0101963:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101968:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010196e:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101975:	08 00 
c0101977:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010197e:	83 e0 e0             	and    $0xffffffe0,%eax
c0101981:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101986:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010198d:	83 e0 1f             	and    $0x1f,%eax
c0101990:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101995:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c010199c:	83 e0 f0             	and    $0xfffffff0,%eax
c010199f:	83 c8 0e             	or     $0xe,%eax
c01019a2:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019a7:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ae:	83 e0 ef             	and    $0xffffffef,%eax
c01019b1:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019b6:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019bd:	83 c8 60             	or     $0x60,%eax
c01019c0:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019cc:	83 c8 80             	or     $0xffffff80,%eax
c01019cf:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d4:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019d9:	c1 e8 10             	shr    $0x10,%eax
c01019dc:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019e2:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019ec:	0f 01 18             	lidtl  (%eax)
    lidt( &idt_pd );
}
c01019ef:	90                   	nop
c01019f0:	c9                   	leave  
c01019f1:	c3                   	ret    

c01019f2 <trapname>:

static const char *
trapname(int trapno) {
c01019f2:	55                   	push   %ebp
c01019f3:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f8:	83 f8 13             	cmp    $0x13,%eax
c01019fb:	77 0c                	ja     c0101a09 <trapname+0x17>
        return excnames[trapno];
c01019fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a00:	8b 04 85 00 65 10 c0 	mov    -0x3fef9b00(,%eax,4),%eax
c0101a07:	eb 18                	jmp    c0101a21 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a09:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a0d:	7e 0d                	jle    c0101a1c <trapname+0x2a>
c0101a0f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a13:	7f 07                	jg     c0101a1c <trapname+0x2a>
        return "Hardware Interrupt";
c0101a15:	b8 aa 61 10 c0       	mov    $0xc01061aa,%eax
c0101a1a:	eb 05                	jmp    c0101a21 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a1c:	b8 bd 61 10 c0       	mov    $0xc01061bd,%eax
}
c0101a21:	5d                   	pop    %ebp
c0101a22:	c3                   	ret    

c0101a23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a23:	55                   	push   %ebp
c0101a24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a2d:	66 83 f8 08          	cmp    $0x8,%ax
c0101a31:	0f 94 c0             	sete   %al
c0101a34:	0f b6 c0             	movzbl %al,%eax
}
c0101a37:	5d                   	pop    %ebp
c0101a38:	c3                   	ret    

c0101a39 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a39:	55                   	push   %ebp
c0101a3a:	89 e5                	mov    %esp,%ebp
c0101a3c:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a3f:	83 ec 08             	sub    $0x8,%esp
c0101a42:	ff 75 08             	pushl  0x8(%ebp)
c0101a45:	68 fe 61 10 c0       	push   $0xc01061fe
c0101a4a:	e8 18 e8 ff ff       	call   c0100267 <cprintf>
c0101a4f:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a55:	83 ec 0c             	sub    $0xc,%esp
c0101a58:	50                   	push   %eax
c0101a59:	e8 b8 01 00 00       	call   c0101c16 <print_regs>
c0101a5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a68:	0f b7 c0             	movzwl %ax,%eax
c0101a6b:	83 ec 08             	sub    $0x8,%esp
c0101a6e:	50                   	push   %eax
c0101a6f:	68 0f 62 10 c0       	push   $0xc010620f
c0101a74:	e8 ee e7 ff ff       	call   c0100267 <cprintf>
c0101a79:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a83:	0f b7 c0             	movzwl %ax,%eax
c0101a86:	83 ec 08             	sub    $0x8,%esp
c0101a89:	50                   	push   %eax
c0101a8a:	68 22 62 10 c0       	push   $0xc0106222
c0101a8f:	e8 d3 e7 ff ff       	call   c0100267 <cprintf>
c0101a94:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a9e:	0f b7 c0             	movzwl %ax,%eax
c0101aa1:	83 ec 08             	sub    $0x8,%esp
c0101aa4:	50                   	push   %eax
c0101aa5:	68 35 62 10 c0       	push   $0xc0106235
c0101aaa:	e8 b8 e7 ff ff       	call   c0100267 <cprintf>
c0101aaf:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ab9:	0f b7 c0             	movzwl %ax,%eax
c0101abc:	83 ec 08             	sub    $0x8,%esp
c0101abf:	50                   	push   %eax
c0101ac0:	68 48 62 10 c0       	push   $0xc0106248
c0101ac5:	e8 9d e7 ff ff       	call   c0100267 <cprintf>
c0101aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad0:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad3:	83 ec 0c             	sub    $0xc,%esp
c0101ad6:	50                   	push   %eax
c0101ad7:	e8 16 ff ff ff       	call   c01019f2 <trapname>
c0101adc:	83 c4 10             	add    $0x10,%esp
c0101adf:	89 c2                	mov    %eax,%edx
c0101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae4:	8b 40 30             	mov    0x30(%eax),%eax
c0101ae7:	83 ec 04             	sub    $0x4,%esp
c0101aea:	52                   	push   %edx
c0101aeb:	50                   	push   %eax
c0101aec:	68 5b 62 10 c0       	push   $0xc010625b
c0101af1:	e8 71 e7 ff ff       	call   c0100267 <cprintf>
c0101af6:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afc:	8b 40 34             	mov    0x34(%eax),%eax
c0101aff:	83 ec 08             	sub    $0x8,%esp
c0101b02:	50                   	push   %eax
c0101b03:	68 6d 62 10 c0       	push   $0xc010626d
c0101b08:	e8 5a e7 ff ff       	call   c0100267 <cprintf>
c0101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 40 38             	mov    0x38(%eax),%eax
c0101b16:	83 ec 08             	sub    $0x8,%esp
c0101b19:	50                   	push   %eax
c0101b1a:	68 7c 62 10 c0       	push   $0xc010627c
c0101b1f:	e8 43 e7 ff ff       	call   c0100267 <cprintf>
c0101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2e:	0f b7 c0             	movzwl %ax,%eax
c0101b31:	83 ec 08             	sub    $0x8,%esp
c0101b34:	50                   	push   %eax
c0101b35:	68 8b 62 10 c0       	push   $0xc010628b
c0101b3a:	e8 28 e7 ff ff       	call   c0100267 <cprintf>
c0101b3f:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b45:	8b 40 40             	mov    0x40(%eax),%eax
c0101b48:	83 ec 08             	sub    $0x8,%esp
c0101b4b:	50                   	push   %eax
c0101b4c:	68 9e 62 10 c0       	push   $0xc010629e
c0101b51:	e8 11 e7 ff ff       	call   c0100267 <cprintf>
c0101b56:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b67:	eb 3f                	jmp    c0101ba8 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6c:	8b 50 40             	mov    0x40(%eax),%edx
c0101b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b72:	21 d0                	and    %edx,%eax
c0101b74:	85 c0                	test   %eax,%eax
c0101b76:	74 29                	je     c0101ba1 <print_trapframe+0x168>
c0101b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b7b:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b82:	85 c0                	test   %eax,%eax
c0101b84:	74 1b                	je     c0101ba1 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b89:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b90:	83 ec 08             	sub    $0x8,%esp
c0101b93:	50                   	push   %eax
c0101b94:	68 ad 62 10 c0       	push   $0xc01062ad
c0101b99:	e8 c9 e6 ff ff       	call   c0100267 <cprintf>
c0101b9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ba5:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bab:	83 f8 17             	cmp    $0x17,%eax
c0101bae:	76 b9                	jbe    c0101b69 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb3:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb6:	25 00 30 00 00       	and    $0x3000,%eax
c0101bbb:	c1 e8 0c             	shr    $0xc,%eax
c0101bbe:	83 ec 08             	sub    $0x8,%esp
c0101bc1:	50                   	push   %eax
c0101bc2:	68 b1 62 10 c0       	push   $0xc01062b1
c0101bc7:	e8 9b e6 ff ff       	call   c0100267 <cprintf>
c0101bcc:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bcf:	83 ec 0c             	sub    $0xc,%esp
c0101bd2:	ff 75 08             	pushl  0x8(%ebp)
c0101bd5:	e8 49 fe ff ff       	call   c0101a23 <trap_in_kernel>
c0101bda:	83 c4 10             	add    $0x10,%esp
c0101bdd:	85 c0                	test   %eax,%eax
c0101bdf:	75 32                	jne    c0101c13 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 44             	mov    0x44(%eax),%eax
c0101be7:	83 ec 08             	sub    $0x8,%esp
c0101bea:	50                   	push   %eax
c0101beb:	68 ba 62 10 c0       	push   $0xc01062ba
c0101bf0:	e8 72 e6 ff ff       	call   c0100267 <cprintf>
c0101bf5:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bff:	0f b7 c0             	movzwl %ax,%eax
c0101c02:	83 ec 08             	sub    $0x8,%esp
c0101c05:	50                   	push   %eax
c0101c06:	68 c9 62 10 c0       	push   $0xc01062c9
c0101c0b:	e8 57 e6 ff ff       	call   c0100267 <cprintf>
c0101c10:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c13:	90                   	nop
c0101c14:	c9                   	leave  
c0101c15:	c3                   	ret    

c0101c16 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c16:	55                   	push   %ebp
c0101c17:	89 e5                	mov    %esp,%ebp
c0101c19:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	8b 00                	mov    (%eax),%eax
c0101c21:	83 ec 08             	sub    $0x8,%esp
c0101c24:	50                   	push   %eax
c0101c25:	68 dc 62 10 c0       	push   $0xc01062dc
c0101c2a:	e8 38 e6 ff ff       	call   c0100267 <cprintf>
c0101c2f:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	8b 40 04             	mov    0x4(%eax),%eax
c0101c38:	83 ec 08             	sub    $0x8,%esp
c0101c3b:	50                   	push   %eax
c0101c3c:	68 eb 62 10 c0       	push   $0xc01062eb
c0101c41:	e8 21 e6 ff ff       	call   c0100267 <cprintf>
c0101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 40 08             	mov    0x8(%eax),%eax
c0101c4f:	83 ec 08             	sub    $0x8,%esp
c0101c52:	50                   	push   %eax
c0101c53:	68 fa 62 10 c0       	push   $0xc01062fa
c0101c58:	e8 0a e6 ff ff       	call   c0100267 <cprintf>
c0101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c66:	83 ec 08             	sub    $0x8,%esp
c0101c69:	50                   	push   %eax
c0101c6a:	68 09 63 10 c0       	push   $0xc0106309
c0101c6f:	e8 f3 e5 ff ff       	call   c0100267 <cprintf>
c0101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 10             	mov    0x10(%eax),%eax
c0101c7d:	83 ec 08             	sub    $0x8,%esp
c0101c80:	50                   	push   %eax
c0101c81:	68 18 63 10 c0       	push   $0xc0106318
c0101c86:	e8 dc e5 ff ff       	call   c0100267 <cprintf>
c0101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 14             	mov    0x14(%eax),%eax
c0101c94:	83 ec 08             	sub    $0x8,%esp
c0101c97:	50                   	push   %eax
c0101c98:	68 27 63 10 c0       	push   $0xc0106327
c0101c9d:	e8 c5 e5 ff ff       	call   c0100267 <cprintf>
c0101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 40 18             	mov    0x18(%eax),%eax
c0101cab:	83 ec 08             	sub    $0x8,%esp
c0101cae:	50                   	push   %eax
c0101caf:	68 36 63 10 c0       	push   $0xc0106336
c0101cb4:	e8 ae e5 ff ff       	call   c0100267 <cprintf>
c0101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cc2:	83 ec 08             	sub    $0x8,%esp
c0101cc5:	50                   	push   %eax
c0101cc6:	68 45 63 10 c0       	push   $0xc0106345
c0101ccb:	e8 97 e5 ff ff       	call   c0100267 <cprintf>
c0101cd0:	83 c4 10             	add    $0x10,%esp
}
c0101cd3:	90                   	nop
c0101cd4:	c9                   	leave  
c0101cd5:	c3                   	ret    

c0101cd6 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cd6:	55                   	push   %ebp
c0101cd7:	89 e5                	mov    %esp,%ebp
c0101cd9:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdf:	8b 40 30             	mov    0x30(%eax),%eax
c0101ce2:	83 f8 2f             	cmp    $0x2f,%eax
c0101ce5:	77 1e                	ja     c0101d05 <trap_dispatch+0x2f>
c0101ce7:	83 f8 2e             	cmp    $0x2e,%eax
c0101cea:	0f 83 b4 00 00 00    	jae    c0101da4 <trap_dispatch+0xce>
c0101cf0:	83 f8 21             	cmp    $0x21,%eax
c0101cf3:	74 3e                	je     c0101d33 <trap_dispatch+0x5d>
c0101cf5:	83 f8 24             	cmp    $0x24,%eax
c0101cf8:	74 15                	je     c0101d0f <trap_dispatch+0x39>
c0101cfa:	83 f8 20             	cmp    $0x20,%eax
c0101cfd:	0f 84 a4 00 00 00    	je     c0101da7 <trap_dispatch+0xd1>
c0101d03:	eb 69                	jmp    c0101d6e <trap_dispatch+0x98>
c0101d05:	83 e8 78             	sub    $0x78,%eax
c0101d08:	83 f8 01             	cmp    $0x1,%eax
c0101d0b:	77 61                	ja     c0101d6e <trap_dispatch+0x98>
c0101d0d:	eb 48                	jmp    c0101d57 <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d0f:	e8 0f f9 ff ff       	call   c0101623 <cons_getc>
c0101d14:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d17:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d1b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d1f:	83 ec 04             	sub    $0x4,%esp
c0101d22:	52                   	push   %edx
c0101d23:	50                   	push   %eax
c0101d24:	68 54 63 10 c0       	push   $0xc0106354
c0101d29:	e8 39 e5 ff ff       	call   c0100267 <cprintf>
c0101d2e:	83 c4 10             	add    $0x10,%esp
        break;
c0101d31:	eb 75                	jmp    c0101da8 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d33:	e8 eb f8 ff ff       	call   c0101623 <cons_getc>
c0101d38:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d3b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d3f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d43:	83 ec 04             	sub    $0x4,%esp
c0101d46:	52                   	push   %edx
c0101d47:	50                   	push   %eax
c0101d48:	68 66 63 10 c0       	push   $0xc0106366
c0101d4d:	e8 15 e5 ff ff       	call   c0100267 <cprintf>
c0101d52:	83 c4 10             	add    $0x10,%esp
        break;
c0101d55:	eb 51                	jmp    c0101da8 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d57:	83 ec 04             	sub    $0x4,%esp
c0101d5a:	68 75 63 10 c0       	push   $0xc0106375
c0101d5f:	68 ac 00 00 00       	push   $0xac
c0101d64:	68 85 63 10 c0       	push   $0xc0106385
c0101d69:	e8 5f e6 ff ff       	call   c01003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d75:	0f b7 c0             	movzwl %ax,%eax
c0101d78:	83 e0 03             	and    $0x3,%eax
c0101d7b:	85 c0                	test   %eax,%eax
c0101d7d:	75 29                	jne    c0101da8 <trap_dispatch+0xd2>
            print_trapframe(tf);
c0101d7f:	83 ec 0c             	sub    $0xc,%esp
c0101d82:	ff 75 08             	pushl  0x8(%ebp)
c0101d85:	e8 af fc ff ff       	call   c0101a39 <print_trapframe>
c0101d8a:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101d8d:	83 ec 04             	sub    $0x4,%esp
c0101d90:	68 96 63 10 c0       	push   $0xc0106396
c0101d95:	68 b6 00 00 00       	push   $0xb6
c0101d9a:	68 85 63 10 c0       	push   $0xc0106385
c0101d9f:	e8 29 e6 ff ff       	call   c01003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101da4:	90                   	nop
c0101da5:	eb 01                	jmp    c0101da8 <trap_dispatch+0xd2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101da7:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101da8:	90                   	nop
c0101da9:	c9                   	leave  
c0101daa:	c3                   	ret    

c0101dab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101dab:	55                   	push   %ebp
c0101dac:	89 e5                	mov    %esp,%ebp
c0101dae:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101db1:	83 ec 0c             	sub    $0xc,%esp
c0101db4:	ff 75 08             	pushl  0x8(%ebp)
c0101db7:	e8 1a ff ff ff       	call   c0101cd6 <trap_dispatch>
c0101dbc:	83 c4 10             	add    $0x10,%esp
}
c0101dbf:	90                   	nop
c0101dc0:	c9                   	leave  
c0101dc1:	c3                   	ret    

c0101dc2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dc2:	6a 00                	push   $0x0
  pushl $0
c0101dc4:	6a 00                	push   $0x0
  jmp __alltraps
c0101dc6:	e9 67 0a 00 00       	jmp    c0102832 <__alltraps>

c0101dcb <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dcb:	6a 00                	push   $0x0
  pushl $1
c0101dcd:	6a 01                	push   $0x1
  jmp __alltraps
c0101dcf:	e9 5e 0a 00 00       	jmp    c0102832 <__alltraps>

c0101dd4 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dd4:	6a 00                	push   $0x0
  pushl $2
c0101dd6:	6a 02                	push   $0x2
  jmp __alltraps
c0101dd8:	e9 55 0a 00 00       	jmp    c0102832 <__alltraps>

c0101ddd <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ddd:	6a 00                	push   $0x0
  pushl $3
c0101ddf:	6a 03                	push   $0x3
  jmp __alltraps
c0101de1:	e9 4c 0a 00 00       	jmp    c0102832 <__alltraps>

c0101de6 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101de6:	6a 00                	push   $0x0
  pushl $4
c0101de8:	6a 04                	push   $0x4
  jmp __alltraps
c0101dea:	e9 43 0a 00 00       	jmp    c0102832 <__alltraps>

c0101def <vector5>:
.globl vector5
vector5:
  pushl $0
c0101def:	6a 00                	push   $0x0
  pushl $5
c0101df1:	6a 05                	push   $0x5
  jmp __alltraps
c0101df3:	e9 3a 0a 00 00       	jmp    c0102832 <__alltraps>

c0101df8 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101df8:	6a 00                	push   $0x0
  pushl $6
c0101dfa:	6a 06                	push   $0x6
  jmp __alltraps
c0101dfc:	e9 31 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e01 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e01:	6a 00                	push   $0x0
  pushl $7
c0101e03:	6a 07                	push   $0x7
  jmp __alltraps
c0101e05:	e9 28 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e0a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e0a:	6a 08                	push   $0x8
  jmp __alltraps
c0101e0c:	e9 21 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e11 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e11:	6a 09                	push   $0x9
  jmp __alltraps
c0101e13:	e9 1a 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e18 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e18:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e1a:	e9 13 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e1f <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e1f:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e21:	e9 0c 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e26 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e26:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e28:	e9 05 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e2d <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e2d:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e2f:	e9 fe 09 00 00       	jmp    c0102832 <__alltraps>

c0101e34 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e34:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e36:	e9 f7 09 00 00       	jmp    c0102832 <__alltraps>

c0101e3b <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e3b:	6a 00                	push   $0x0
  pushl $15
c0101e3d:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e3f:	e9 ee 09 00 00       	jmp    c0102832 <__alltraps>

c0101e44 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e44:	6a 00                	push   $0x0
  pushl $16
c0101e46:	6a 10                	push   $0x10
  jmp __alltraps
c0101e48:	e9 e5 09 00 00       	jmp    c0102832 <__alltraps>

c0101e4d <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e4d:	6a 11                	push   $0x11
  jmp __alltraps
c0101e4f:	e9 de 09 00 00       	jmp    c0102832 <__alltraps>

c0101e54 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e54:	6a 00                	push   $0x0
  pushl $18
c0101e56:	6a 12                	push   $0x12
  jmp __alltraps
c0101e58:	e9 d5 09 00 00       	jmp    c0102832 <__alltraps>

c0101e5d <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e5d:	6a 00                	push   $0x0
  pushl $19
c0101e5f:	6a 13                	push   $0x13
  jmp __alltraps
c0101e61:	e9 cc 09 00 00       	jmp    c0102832 <__alltraps>

c0101e66 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e66:	6a 00                	push   $0x0
  pushl $20
c0101e68:	6a 14                	push   $0x14
  jmp __alltraps
c0101e6a:	e9 c3 09 00 00       	jmp    c0102832 <__alltraps>

c0101e6f <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $21
c0101e71:	6a 15                	push   $0x15
  jmp __alltraps
c0101e73:	e9 ba 09 00 00       	jmp    c0102832 <__alltraps>

c0101e78 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $22
c0101e7a:	6a 16                	push   $0x16
  jmp __alltraps
c0101e7c:	e9 b1 09 00 00       	jmp    c0102832 <__alltraps>

c0101e81 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $23
c0101e83:	6a 17                	push   $0x17
  jmp __alltraps
c0101e85:	e9 a8 09 00 00       	jmp    c0102832 <__alltraps>

c0101e8a <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $24
c0101e8c:	6a 18                	push   $0x18
  jmp __alltraps
c0101e8e:	e9 9f 09 00 00       	jmp    c0102832 <__alltraps>

c0101e93 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e93:	6a 00                	push   $0x0
  pushl $25
c0101e95:	6a 19                	push   $0x19
  jmp __alltraps
c0101e97:	e9 96 09 00 00       	jmp    c0102832 <__alltraps>

c0101e9c <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e9c:	6a 00                	push   $0x0
  pushl $26
c0101e9e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ea0:	e9 8d 09 00 00       	jmp    c0102832 <__alltraps>

c0101ea5 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ea5:	6a 00                	push   $0x0
  pushl $27
c0101ea7:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ea9:	e9 84 09 00 00       	jmp    c0102832 <__alltraps>

c0101eae <vector28>:
.globl vector28
vector28:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $28
c0101eb0:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101eb2:	e9 7b 09 00 00       	jmp    c0102832 <__alltraps>

c0101eb7 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eb7:	6a 00                	push   $0x0
  pushl $29
c0101eb9:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ebb:	e9 72 09 00 00       	jmp    c0102832 <__alltraps>

c0101ec0 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  pushl $30
c0101ec2:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ec4:	e9 69 09 00 00       	jmp    c0102832 <__alltraps>

c0101ec9 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ec9:	6a 00                	push   $0x0
  pushl $31
c0101ecb:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ecd:	e9 60 09 00 00       	jmp    c0102832 <__alltraps>

c0101ed2 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ed2:	6a 00                	push   $0x0
  pushl $32
c0101ed4:	6a 20                	push   $0x20
  jmp __alltraps
c0101ed6:	e9 57 09 00 00       	jmp    c0102832 <__alltraps>

c0101edb <vector33>:
.globl vector33
vector33:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $33
c0101edd:	6a 21                	push   $0x21
  jmp __alltraps
c0101edf:	e9 4e 09 00 00       	jmp    c0102832 <__alltraps>

c0101ee4 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $34
c0101ee6:	6a 22                	push   $0x22
  jmp __alltraps
c0101ee8:	e9 45 09 00 00       	jmp    c0102832 <__alltraps>

c0101eed <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $35
c0101eef:	6a 23                	push   $0x23
  jmp __alltraps
c0101ef1:	e9 3c 09 00 00       	jmp    c0102832 <__alltraps>

c0101ef6 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $36
c0101ef8:	6a 24                	push   $0x24
  jmp __alltraps
c0101efa:	e9 33 09 00 00       	jmp    c0102832 <__alltraps>

c0101eff <vector37>:
.globl vector37
vector37:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $37
c0101f01:	6a 25                	push   $0x25
  jmp __alltraps
c0101f03:	e9 2a 09 00 00       	jmp    c0102832 <__alltraps>

c0101f08 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $38
c0101f0a:	6a 26                	push   $0x26
  jmp __alltraps
c0101f0c:	e9 21 09 00 00       	jmp    c0102832 <__alltraps>

c0101f11 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $39
c0101f13:	6a 27                	push   $0x27
  jmp __alltraps
c0101f15:	e9 18 09 00 00       	jmp    c0102832 <__alltraps>

c0101f1a <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $40
c0101f1c:	6a 28                	push   $0x28
  jmp __alltraps
c0101f1e:	e9 0f 09 00 00       	jmp    c0102832 <__alltraps>

c0101f23 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $41
c0101f25:	6a 29                	push   $0x29
  jmp __alltraps
c0101f27:	e9 06 09 00 00       	jmp    c0102832 <__alltraps>

c0101f2c <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $42
c0101f2e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f30:	e9 fd 08 00 00       	jmp    c0102832 <__alltraps>

c0101f35 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $43
c0101f37:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f39:	e9 f4 08 00 00       	jmp    c0102832 <__alltraps>

c0101f3e <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $44
c0101f40:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f42:	e9 eb 08 00 00       	jmp    c0102832 <__alltraps>

c0101f47 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $45
c0101f49:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f4b:	e9 e2 08 00 00       	jmp    c0102832 <__alltraps>

c0101f50 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $46
c0101f52:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f54:	e9 d9 08 00 00       	jmp    c0102832 <__alltraps>

c0101f59 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $47
c0101f5b:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f5d:	e9 d0 08 00 00       	jmp    c0102832 <__alltraps>

c0101f62 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $48
c0101f64:	6a 30                	push   $0x30
  jmp __alltraps
c0101f66:	e9 c7 08 00 00       	jmp    c0102832 <__alltraps>

c0101f6b <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $49
c0101f6d:	6a 31                	push   $0x31
  jmp __alltraps
c0101f6f:	e9 be 08 00 00       	jmp    c0102832 <__alltraps>

c0101f74 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $50
c0101f76:	6a 32                	push   $0x32
  jmp __alltraps
c0101f78:	e9 b5 08 00 00       	jmp    c0102832 <__alltraps>

c0101f7d <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $51
c0101f7f:	6a 33                	push   $0x33
  jmp __alltraps
c0101f81:	e9 ac 08 00 00       	jmp    c0102832 <__alltraps>

c0101f86 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $52
c0101f88:	6a 34                	push   $0x34
  jmp __alltraps
c0101f8a:	e9 a3 08 00 00       	jmp    c0102832 <__alltraps>

c0101f8f <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $53
c0101f91:	6a 35                	push   $0x35
  jmp __alltraps
c0101f93:	e9 9a 08 00 00       	jmp    c0102832 <__alltraps>

c0101f98 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $54
c0101f9a:	6a 36                	push   $0x36
  jmp __alltraps
c0101f9c:	e9 91 08 00 00       	jmp    c0102832 <__alltraps>

c0101fa1 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $55
c0101fa3:	6a 37                	push   $0x37
  jmp __alltraps
c0101fa5:	e9 88 08 00 00       	jmp    c0102832 <__alltraps>

c0101faa <vector56>:
.globl vector56
vector56:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $56
c0101fac:	6a 38                	push   $0x38
  jmp __alltraps
c0101fae:	e9 7f 08 00 00       	jmp    c0102832 <__alltraps>

c0101fb3 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $57
c0101fb5:	6a 39                	push   $0x39
  jmp __alltraps
c0101fb7:	e9 76 08 00 00       	jmp    c0102832 <__alltraps>

c0101fbc <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $58
c0101fbe:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fc0:	e9 6d 08 00 00       	jmp    c0102832 <__alltraps>

c0101fc5 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $59
c0101fc7:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fc9:	e9 64 08 00 00       	jmp    c0102832 <__alltraps>

c0101fce <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $60
c0101fd0:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fd2:	e9 5b 08 00 00       	jmp    c0102832 <__alltraps>

c0101fd7 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $61
c0101fd9:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fdb:	e9 52 08 00 00       	jmp    c0102832 <__alltraps>

c0101fe0 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $62
c0101fe2:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fe4:	e9 49 08 00 00       	jmp    c0102832 <__alltraps>

c0101fe9 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $63
c0101feb:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fed:	e9 40 08 00 00       	jmp    c0102832 <__alltraps>

c0101ff2 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $64
c0101ff4:	6a 40                	push   $0x40
  jmp __alltraps
c0101ff6:	e9 37 08 00 00       	jmp    c0102832 <__alltraps>

c0101ffb <vector65>:
.globl vector65
vector65:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $65
c0101ffd:	6a 41                	push   $0x41
  jmp __alltraps
c0101fff:	e9 2e 08 00 00       	jmp    c0102832 <__alltraps>

c0102004 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $66
c0102006:	6a 42                	push   $0x42
  jmp __alltraps
c0102008:	e9 25 08 00 00       	jmp    c0102832 <__alltraps>

c010200d <vector67>:
.globl vector67
vector67:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $67
c010200f:	6a 43                	push   $0x43
  jmp __alltraps
c0102011:	e9 1c 08 00 00       	jmp    c0102832 <__alltraps>

c0102016 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $68
c0102018:	6a 44                	push   $0x44
  jmp __alltraps
c010201a:	e9 13 08 00 00       	jmp    c0102832 <__alltraps>

c010201f <vector69>:
.globl vector69
vector69:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $69
c0102021:	6a 45                	push   $0x45
  jmp __alltraps
c0102023:	e9 0a 08 00 00       	jmp    c0102832 <__alltraps>

c0102028 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $70
c010202a:	6a 46                	push   $0x46
  jmp __alltraps
c010202c:	e9 01 08 00 00       	jmp    c0102832 <__alltraps>

c0102031 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $71
c0102033:	6a 47                	push   $0x47
  jmp __alltraps
c0102035:	e9 f8 07 00 00       	jmp    c0102832 <__alltraps>

c010203a <vector72>:
.globl vector72
vector72:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $72
c010203c:	6a 48                	push   $0x48
  jmp __alltraps
c010203e:	e9 ef 07 00 00       	jmp    c0102832 <__alltraps>

c0102043 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $73
c0102045:	6a 49                	push   $0x49
  jmp __alltraps
c0102047:	e9 e6 07 00 00       	jmp    c0102832 <__alltraps>

c010204c <vector74>:
.globl vector74
vector74:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $74
c010204e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102050:	e9 dd 07 00 00       	jmp    c0102832 <__alltraps>

c0102055 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $75
c0102057:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102059:	e9 d4 07 00 00       	jmp    c0102832 <__alltraps>

c010205e <vector76>:
.globl vector76
vector76:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $76
c0102060:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102062:	e9 cb 07 00 00       	jmp    c0102832 <__alltraps>

c0102067 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $77
c0102069:	6a 4d                	push   $0x4d
  jmp __alltraps
c010206b:	e9 c2 07 00 00       	jmp    c0102832 <__alltraps>

c0102070 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $78
c0102072:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102074:	e9 b9 07 00 00       	jmp    c0102832 <__alltraps>

c0102079 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $79
c010207b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010207d:	e9 b0 07 00 00       	jmp    c0102832 <__alltraps>

c0102082 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $80
c0102084:	6a 50                	push   $0x50
  jmp __alltraps
c0102086:	e9 a7 07 00 00       	jmp    c0102832 <__alltraps>

c010208b <vector81>:
.globl vector81
vector81:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $81
c010208d:	6a 51                	push   $0x51
  jmp __alltraps
c010208f:	e9 9e 07 00 00       	jmp    c0102832 <__alltraps>

c0102094 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $82
c0102096:	6a 52                	push   $0x52
  jmp __alltraps
c0102098:	e9 95 07 00 00       	jmp    c0102832 <__alltraps>

c010209d <vector83>:
.globl vector83
vector83:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $83
c010209f:	6a 53                	push   $0x53
  jmp __alltraps
c01020a1:	e9 8c 07 00 00       	jmp    c0102832 <__alltraps>

c01020a6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $84
c01020a8:	6a 54                	push   $0x54
  jmp __alltraps
c01020aa:	e9 83 07 00 00       	jmp    c0102832 <__alltraps>

c01020af <vector85>:
.globl vector85
vector85:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $85
c01020b1:	6a 55                	push   $0x55
  jmp __alltraps
c01020b3:	e9 7a 07 00 00       	jmp    c0102832 <__alltraps>

c01020b8 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $86
c01020ba:	6a 56                	push   $0x56
  jmp __alltraps
c01020bc:	e9 71 07 00 00       	jmp    c0102832 <__alltraps>

c01020c1 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $87
c01020c3:	6a 57                	push   $0x57
  jmp __alltraps
c01020c5:	e9 68 07 00 00       	jmp    c0102832 <__alltraps>

c01020ca <vector88>:
.globl vector88
vector88:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $88
c01020cc:	6a 58                	push   $0x58
  jmp __alltraps
c01020ce:	e9 5f 07 00 00       	jmp    c0102832 <__alltraps>

c01020d3 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $89
c01020d5:	6a 59                	push   $0x59
  jmp __alltraps
c01020d7:	e9 56 07 00 00       	jmp    c0102832 <__alltraps>

c01020dc <vector90>:
.globl vector90
vector90:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $90
c01020de:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020e0:	e9 4d 07 00 00       	jmp    c0102832 <__alltraps>

c01020e5 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $91
c01020e7:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020e9:	e9 44 07 00 00       	jmp    c0102832 <__alltraps>

c01020ee <vector92>:
.globl vector92
vector92:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $92
c01020f0:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020f2:	e9 3b 07 00 00       	jmp    c0102832 <__alltraps>

c01020f7 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $93
c01020f9:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020fb:	e9 32 07 00 00       	jmp    c0102832 <__alltraps>

c0102100 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $94
c0102102:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102104:	e9 29 07 00 00       	jmp    c0102832 <__alltraps>

c0102109 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $95
c010210b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010210d:	e9 20 07 00 00       	jmp    c0102832 <__alltraps>

c0102112 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $96
c0102114:	6a 60                	push   $0x60
  jmp __alltraps
c0102116:	e9 17 07 00 00       	jmp    c0102832 <__alltraps>

c010211b <vector97>:
.globl vector97
vector97:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $97
c010211d:	6a 61                	push   $0x61
  jmp __alltraps
c010211f:	e9 0e 07 00 00       	jmp    c0102832 <__alltraps>

c0102124 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $98
c0102126:	6a 62                	push   $0x62
  jmp __alltraps
c0102128:	e9 05 07 00 00       	jmp    c0102832 <__alltraps>

c010212d <vector99>:
.globl vector99
vector99:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $99
c010212f:	6a 63                	push   $0x63
  jmp __alltraps
c0102131:	e9 fc 06 00 00       	jmp    c0102832 <__alltraps>

c0102136 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $100
c0102138:	6a 64                	push   $0x64
  jmp __alltraps
c010213a:	e9 f3 06 00 00       	jmp    c0102832 <__alltraps>

c010213f <vector101>:
.globl vector101
vector101:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $101
c0102141:	6a 65                	push   $0x65
  jmp __alltraps
c0102143:	e9 ea 06 00 00       	jmp    c0102832 <__alltraps>

c0102148 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $102
c010214a:	6a 66                	push   $0x66
  jmp __alltraps
c010214c:	e9 e1 06 00 00       	jmp    c0102832 <__alltraps>

c0102151 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $103
c0102153:	6a 67                	push   $0x67
  jmp __alltraps
c0102155:	e9 d8 06 00 00       	jmp    c0102832 <__alltraps>

c010215a <vector104>:
.globl vector104
vector104:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $104
c010215c:	6a 68                	push   $0x68
  jmp __alltraps
c010215e:	e9 cf 06 00 00       	jmp    c0102832 <__alltraps>

c0102163 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $105
c0102165:	6a 69                	push   $0x69
  jmp __alltraps
c0102167:	e9 c6 06 00 00       	jmp    c0102832 <__alltraps>

c010216c <vector106>:
.globl vector106
vector106:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $106
c010216e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102170:	e9 bd 06 00 00       	jmp    c0102832 <__alltraps>

c0102175 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $107
c0102177:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102179:	e9 b4 06 00 00       	jmp    c0102832 <__alltraps>

c010217e <vector108>:
.globl vector108
vector108:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $108
c0102180:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102182:	e9 ab 06 00 00       	jmp    c0102832 <__alltraps>

c0102187 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $109
c0102189:	6a 6d                	push   $0x6d
  jmp __alltraps
c010218b:	e9 a2 06 00 00       	jmp    c0102832 <__alltraps>

c0102190 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $110
c0102192:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102194:	e9 99 06 00 00       	jmp    c0102832 <__alltraps>

c0102199 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $111
c010219b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010219d:	e9 90 06 00 00       	jmp    c0102832 <__alltraps>

c01021a2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $112
c01021a4:	6a 70                	push   $0x70
  jmp __alltraps
c01021a6:	e9 87 06 00 00       	jmp    c0102832 <__alltraps>

c01021ab <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $113
c01021ad:	6a 71                	push   $0x71
  jmp __alltraps
c01021af:	e9 7e 06 00 00       	jmp    c0102832 <__alltraps>

c01021b4 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $114
c01021b6:	6a 72                	push   $0x72
  jmp __alltraps
c01021b8:	e9 75 06 00 00       	jmp    c0102832 <__alltraps>

c01021bd <vector115>:
.globl vector115
vector115:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $115
c01021bf:	6a 73                	push   $0x73
  jmp __alltraps
c01021c1:	e9 6c 06 00 00       	jmp    c0102832 <__alltraps>

c01021c6 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $116
c01021c8:	6a 74                	push   $0x74
  jmp __alltraps
c01021ca:	e9 63 06 00 00       	jmp    c0102832 <__alltraps>

c01021cf <vector117>:
.globl vector117
vector117:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $117
c01021d1:	6a 75                	push   $0x75
  jmp __alltraps
c01021d3:	e9 5a 06 00 00       	jmp    c0102832 <__alltraps>

c01021d8 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $118
c01021da:	6a 76                	push   $0x76
  jmp __alltraps
c01021dc:	e9 51 06 00 00       	jmp    c0102832 <__alltraps>

c01021e1 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $119
c01021e3:	6a 77                	push   $0x77
  jmp __alltraps
c01021e5:	e9 48 06 00 00       	jmp    c0102832 <__alltraps>

c01021ea <vector120>:
.globl vector120
vector120:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $120
c01021ec:	6a 78                	push   $0x78
  jmp __alltraps
c01021ee:	e9 3f 06 00 00       	jmp    c0102832 <__alltraps>

c01021f3 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $121
c01021f5:	6a 79                	push   $0x79
  jmp __alltraps
c01021f7:	e9 36 06 00 00       	jmp    c0102832 <__alltraps>

c01021fc <vector122>:
.globl vector122
vector122:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $122
c01021fe:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102200:	e9 2d 06 00 00       	jmp    c0102832 <__alltraps>

c0102205 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $123
c0102207:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102209:	e9 24 06 00 00       	jmp    c0102832 <__alltraps>

c010220e <vector124>:
.globl vector124
vector124:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $124
c0102210:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102212:	e9 1b 06 00 00       	jmp    c0102832 <__alltraps>

c0102217 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $125
c0102219:	6a 7d                	push   $0x7d
  jmp __alltraps
c010221b:	e9 12 06 00 00       	jmp    c0102832 <__alltraps>

c0102220 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $126
c0102222:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102224:	e9 09 06 00 00       	jmp    c0102832 <__alltraps>

c0102229 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $127
c010222b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010222d:	e9 00 06 00 00       	jmp    c0102832 <__alltraps>

c0102232 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $128
c0102234:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102239:	e9 f4 05 00 00       	jmp    c0102832 <__alltraps>

c010223e <vector129>:
.globl vector129
vector129:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $129
c0102240:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102245:	e9 e8 05 00 00       	jmp    c0102832 <__alltraps>

c010224a <vector130>:
.globl vector130
vector130:
  pushl $0
c010224a:	6a 00                	push   $0x0
  pushl $130
c010224c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102251:	e9 dc 05 00 00       	jmp    c0102832 <__alltraps>

c0102256 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $131
c0102258:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010225d:	e9 d0 05 00 00       	jmp    c0102832 <__alltraps>

c0102262 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $132
c0102264:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102269:	e9 c4 05 00 00       	jmp    c0102832 <__alltraps>

c010226e <vector133>:
.globl vector133
vector133:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $133
c0102270:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102275:	e9 b8 05 00 00       	jmp    c0102832 <__alltraps>

c010227a <vector134>:
.globl vector134
vector134:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $134
c010227c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102281:	e9 ac 05 00 00       	jmp    c0102832 <__alltraps>

c0102286 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $135
c0102288:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010228d:	e9 a0 05 00 00       	jmp    c0102832 <__alltraps>

c0102292 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $136
c0102294:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102299:	e9 94 05 00 00       	jmp    c0102832 <__alltraps>

c010229e <vector137>:
.globl vector137
vector137:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $137
c01022a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022a5:	e9 88 05 00 00       	jmp    c0102832 <__alltraps>

c01022aa <vector138>:
.globl vector138
vector138:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $138
c01022ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022b1:	e9 7c 05 00 00       	jmp    c0102832 <__alltraps>

c01022b6 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $139
c01022b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022bd:	e9 70 05 00 00       	jmp    c0102832 <__alltraps>

c01022c2 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $140
c01022c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022c9:	e9 64 05 00 00       	jmp    c0102832 <__alltraps>

c01022ce <vector141>:
.globl vector141
vector141:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $141
c01022d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022d5:	e9 58 05 00 00       	jmp    c0102832 <__alltraps>

c01022da <vector142>:
.globl vector142
vector142:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $142
c01022dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022e1:	e9 4c 05 00 00       	jmp    c0102832 <__alltraps>

c01022e6 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $143
c01022e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022ed:	e9 40 05 00 00       	jmp    c0102832 <__alltraps>

c01022f2 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $144
c01022f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022f9:	e9 34 05 00 00       	jmp    c0102832 <__alltraps>

c01022fe <vector145>:
.globl vector145
vector145:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $145
c0102300:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102305:	e9 28 05 00 00       	jmp    c0102832 <__alltraps>

c010230a <vector146>:
.globl vector146
vector146:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $146
c010230c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102311:	e9 1c 05 00 00       	jmp    c0102832 <__alltraps>

c0102316 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $147
c0102318:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010231d:	e9 10 05 00 00       	jmp    c0102832 <__alltraps>

c0102322 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $148
c0102324:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102329:	e9 04 05 00 00       	jmp    c0102832 <__alltraps>

c010232e <vector149>:
.globl vector149
vector149:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $149
c0102330:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102335:	e9 f8 04 00 00       	jmp    c0102832 <__alltraps>

c010233a <vector150>:
.globl vector150
vector150:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $150
c010233c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102341:	e9 ec 04 00 00       	jmp    c0102832 <__alltraps>

c0102346 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $151
c0102348:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010234d:	e9 e0 04 00 00       	jmp    c0102832 <__alltraps>

c0102352 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $152
c0102354:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102359:	e9 d4 04 00 00       	jmp    c0102832 <__alltraps>

c010235e <vector153>:
.globl vector153
vector153:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $153
c0102360:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102365:	e9 c8 04 00 00       	jmp    c0102832 <__alltraps>

c010236a <vector154>:
.globl vector154
vector154:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $154
c010236c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102371:	e9 bc 04 00 00       	jmp    c0102832 <__alltraps>

c0102376 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $155
c0102378:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010237d:	e9 b0 04 00 00       	jmp    c0102832 <__alltraps>

c0102382 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $156
c0102384:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102389:	e9 a4 04 00 00       	jmp    c0102832 <__alltraps>

c010238e <vector157>:
.globl vector157
vector157:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $157
c0102390:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102395:	e9 98 04 00 00       	jmp    c0102832 <__alltraps>

c010239a <vector158>:
.globl vector158
vector158:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $158
c010239c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023a1:	e9 8c 04 00 00       	jmp    c0102832 <__alltraps>

c01023a6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $159
c01023a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023ad:	e9 80 04 00 00       	jmp    c0102832 <__alltraps>

c01023b2 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $160
c01023b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023b9:	e9 74 04 00 00       	jmp    c0102832 <__alltraps>

c01023be <vector161>:
.globl vector161
vector161:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $161
c01023c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023c5:	e9 68 04 00 00       	jmp    c0102832 <__alltraps>

c01023ca <vector162>:
.globl vector162
vector162:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $162
c01023cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023d1:	e9 5c 04 00 00       	jmp    c0102832 <__alltraps>

c01023d6 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $163
c01023d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023dd:	e9 50 04 00 00       	jmp    c0102832 <__alltraps>

c01023e2 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $164
c01023e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023e9:	e9 44 04 00 00       	jmp    c0102832 <__alltraps>

c01023ee <vector165>:
.globl vector165
vector165:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $165
c01023f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023f5:	e9 38 04 00 00       	jmp    c0102832 <__alltraps>

c01023fa <vector166>:
.globl vector166
vector166:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $166
c01023fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102401:	e9 2c 04 00 00       	jmp    c0102832 <__alltraps>

c0102406 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $167
c0102408:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010240d:	e9 20 04 00 00       	jmp    c0102832 <__alltraps>

c0102412 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $168
c0102414:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102419:	e9 14 04 00 00       	jmp    c0102832 <__alltraps>

c010241e <vector169>:
.globl vector169
vector169:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $169
c0102420:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102425:	e9 08 04 00 00       	jmp    c0102832 <__alltraps>

c010242a <vector170>:
.globl vector170
vector170:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $170
c010242c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102431:	e9 fc 03 00 00       	jmp    c0102832 <__alltraps>

c0102436 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $171
c0102438:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010243d:	e9 f0 03 00 00       	jmp    c0102832 <__alltraps>

c0102442 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $172
c0102444:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102449:	e9 e4 03 00 00       	jmp    c0102832 <__alltraps>

c010244e <vector173>:
.globl vector173
vector173:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $173
c0102450:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102455:	e9 d8 03 00 00       	jmp    c0102832 <__alltraps>

c010245a <vector174>:
.globl vector174
vector174:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $174
c010245c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102461:	e9 cc 03 00 00       	jmp    c0102832 <__alltraps>

c0102466 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $175
c0102468:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010246d:	e9 c0 03 00 00       	jmp    c0102832 <__alltraps>

c0102472 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $176
c0102474:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102479:	e9 b4 03 00 00       	jmp    c0102832 <__alltraps>

c010247e <vector177>:
.globl vector177
vector177:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $177
c0102480:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102485:	e9 a8 03 00 00       	jmp    c0102832 <__alltraps>

c010248a <vector178>:
.globl vector178
vector178:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $178
c010248c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102491:	e9 9c 03 00 00       	jmp    c0102832 <__alltraps>

c0102496 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $179
c0102498:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010249d:	e9 90 03 00 00       	jmp    c0102832 <__alltraps>

c01024a2 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $180
c01024a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024a9:	e9 84 03 00 00       	jmp    c0102832 <__alltraps>

c01024ae <vector181>:
.globl vector181
vector181:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $181
c01024b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024b5:	e9 78 03 00 00       	jmp    c0102832 <__alltraps>

c01024ba <vector182>:
.globl vector182
vector182:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $182
c01024bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024c1:	e9 6c 03 00 00       	jmp    c0102832 <__alltraps>

c01024c6 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $183
c01024c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024cd:	e9 60 03 00 00       	jmp    c0102832 <__alltraps>

c01024d2 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $184
c01024d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024d9:	e9 54 03 00 00       	jmp    c0102832 <__alltraps>

c01024de <vector185>:
.globl vector185
vector185:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $185
c01024e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024e5:	e9 48 03 00 00       	jmp    c0102832 <__alltraps>

c01024ea <vector186>:
.globl vector186
vector186:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $186
c01024ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024f1:	e9 3c 03 00 00       	jmp    c0102832 <__alltraps>

c01024f6 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $187
c01024f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024fd:	e9 30 03 00 00       	jmp    c0102832 <__alltraps>

c0102502 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $188
c0102504:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102509:	e9 24 03 00 00       	jmp    c0102832 <__alltraps>

c010250e <vector189>:
.globl vector189
vector189:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $189
c0102510:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102515:	e9 18 03 00 00       	jmp    c0102832 <__alltraps>

c010251a <vector190>:
.globl vector190
vector190:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $190
c010251c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102521:	e9 0c 03 00 00       	jmp    c0102832 <__alltraps>

c0102526 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $191
c0102528:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010252d:	e9 00 03 00 00       	jmp    c0102832 <__alltraps>

c0102532 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $192
c0102534:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102539:	e9 f4 02 00 00       	jmp    c0102832 <__alltraps>

c010253e <vector193>:
.globl vector193
vector193:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $193
c0102540:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102545:	e9 e8 02 00 00       	jmp    c0102832 <__alltraps>

c010254a <vector194>:
.globl vector194
vector194:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $194
c010254c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102551:	e9 dc 02 00 00       	jmp    c0102832 <__alltraps>

c0102556 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $195
c0102558:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010255d:	e9 d0 02 00 00       	jmp    c0102832 <__alltraps>

c0102562 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $196
c0102564:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102569:	e9 c4 02 00 00       	jmp    c0102832 <__alltraps>

c010256e <vector197>:
.globl vector197
vector197:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $197
c0102570:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102575:	e9 b8 02 00 00       	jmp    c0102832 <__alltraps>

c010257a <vector198>:
.globl vector198
vector198:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $198
c010257c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102581:	e9 ac 02 00 00       	jmp    c0102832 <__alltraps>

c0102586 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $199
c0102588:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010258d:	e9 a0 02 00 00       	jmp    c0102832 <__alltraps>

c0102592 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $200
c0102594:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102599:	e9 94 02 00 00       	jmp    c0102832 <__alltraps>

c010259e <vector201>:
.globl vector201
vector201:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $201
c01025a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025a5:	e9 88 02 00 00       	jmp    c0102832 <__alltraps>

c01025aa <vector202>:
.globl vector202
vector202:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $202
c01025ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025b1:	e9 7c 02 00 00       	jmp    c0102832 <__alltraps>

c01025b6 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $203
c01025b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025bd:	e9 70 02 00 00       	jmp    c0102832 <__alltraps>

c01025c2 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $204
c01025c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025c9:	e9 64 02 00 00       	jmp    c0102832 <__alltraps>

c01025ce <vector205>:
.globl vector205
vector205:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $205
c01025d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025d5:	e9 58 02 00 00       	jmp    c0102832 <__alltraps>

c01025da <vector206>:
.globl vector206
vector206:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $206
c01025dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025e1:	e9 4c 02 00 00       	jmp    c0102832 <__alltraps>

c01025e6 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $207
c01025e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025ed:	e9 40 02 00 00       	jmp    c0102832 <__alltraps>

c01025f2 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $208
c01025f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025f9:	e9 34 02 00 00       	jmp    c0102832 <__alltraps>

c01025fe <vector209>:
.globl vector209
vector209:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $209
c0102600:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102605:	e9 28 02 00 00       	jmp    c0102832 <__alltraps>

c010260a <vector210>:
.globl vector210
vector210:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $210
c010260c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102611:	e9 1c 02 00 00       	jmp    c0102832 <__alltraps>

c0102616 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $211
c0102618:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010261d:	e9 10 02 00 00       	jmp    c0102832 <__alltraps>

c0102622 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $212
c0102624:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102629:	e9 04 02 00 00       	jmp    c0102832 <__alltraps>

c010262e <vector213>:
.globl vector213
vector213:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $213
c0102630:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102635:	e9 f8 01 00 00       	jmp    c0102832 <__alltraps>

c010263a <vector214>:
.globl vector214
vector214:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $214
c010263c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102641:	e9 ec 01 00 00       	jmp    c0102832 <__alltraps>

c0102646 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $215
c0102648:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010264d:	e9 e0 01 00 00       	jmp    c0102832 <__alltraps>

c0102652 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $216
c0102654:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102659:	e9 d4 01 00 00       	jmp    c0102832 <__alltraps>

c010265e <vector217>:
.globl vector217
vector217:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $217
c0102660:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102665:	e9 c8 01 00 00       	jmp    c0102832 <__alltraps>

c010266a <vector218>:
.globl vector218
vector218:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $218
c010266c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102671:	e9 bc 01 00 00       	jmp    c0102832 <__alltraps>

c0102676 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $219
c0102678:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010267d:	e9 b0 01 00 00       	jmp    c0102832 <__alltraps>

c0102682 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $220
c0102684:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102689:	e9 a4 01 00 00       	jmp    c0102832 <__alltraps>

c010268e <vector221>:
.globl vector221
vector221:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $221
c0102690:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102695:	e9 98 01 00 00       	jmp    c0102832 <__alltraps>

c010269a <vector222>:
.globl vector222
vector222:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $222
c010269c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026a1:	e9 8c 01 00 00       	jmp    c0102832 <__alltraps>

c01026a6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $223
c01026a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026ad:	e9 80 01 00 00       	jmp    c0102832 <__alltraps>

c01026b2 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $224
c01026b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026b9:	e9 74 01 00 00       	jmp    c0102832 <__alltraps>

c01026be <vector225>:
.globl vector225
vector225:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $225
c01026c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026c5:	e9 68 01 00 00       	jmp    c0102832 <__alltraps>

c01026ca <vector226>:
.globl vector226
vector226:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $226
c01026cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026d1:	e9 5c 01 00 00       	jmp    c0102832 <__alltraps>

c01026d6 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $227
c01026d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026dd:	e9 50 01 00 00       	jmp    c0102832 <__alltraps>

c01026e2 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $228
c01026e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026e9:	e9 44 01 00 00       	jmp    c0102832 <__alltraps>

c01026ee <vector229>:
.globl vector229
vector229:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $229
c01026f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026f5:	e9 38 01 00 00       	jmp    c0102832 <__alltraps>

c01026fa <vector230>:
.globl vector230
vector230:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $230
c01026fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102701:	e9 2c 01 00 00       	jmp    c0102832 <__alltraps>

c0102706 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $231
c0102708:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010270d:	e9 20 01 00 00       	jmp    c0102832 <__alltraps>

c0102712 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $232
c0102714:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102719:	e9 14 01 00 00       	jmp    c0102832 <__alltraps>

c010271e <vector233>:
.globl vector233
vector233:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $233
c0102720:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102725:	e9 08 01 00 00       	jmp    c0102832 <__alltraps>

c010272a <vector234>:
.globl vector234
vector234:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $234
c010272c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102731:	e9 fc 00 00 00       	jmp    c0102832 <__alltraps>

c0102736 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $235
c0102738:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010273d:	e9 f0 00 00 00       	jmp    c0102832 <__alltraps>

c0102742 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $236
c0102744:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102749:	e9 e4 00 00 00       	jmp    c0102832 <__alltraps>

c010274e <vector237>:
.globl vector237
vector237:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $237
c0102750:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102755:	e9 d8 00 00 00       	jmp    c0102832 <__alltraps>

c010275a <vector238>:
.globl vector238
vector238:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $238
c010275c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102761:	e9 cc 00 00 00       	jmp    c0102832 <__alltraps>

c0102766 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $239
c0102768:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010276d:	e9 c0 00 00 00       	jmp    c0102832 <__alltraps>

c0102772 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $240
c0102774:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102779:	e9 b4 00 00 00       	jmp    c0102832 <__alltraps>

c010277e <vector241>:
.globl vector241
vector241:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $241
c0102780:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102785:	e9 a8 00 00 00       	jmp    c0102832 <__alltraps>

c010278a <vector242>:
.globl vector242
vector242:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $242
c010278c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102791:	e9 9c 00 00 00       	jmp    c0102832 <__alltraps>

c0102796 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $243
c0102798:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010279d:	e9 90 00 00 00       	jmp    c0102832 <__alltraps>

c01027a2 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $244
c01027a4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027a9:	e9 84 00 00 00       	jmp    c0102832 <__alltraps>

c01027ae <vector245>:
.globl vector245
vector245:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $245
c01027b0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027b5:	e9 78 00 00 00       	jmp    c0102832 <__alltraps>

c01027ba <vector246>:
.globl vector246
vector246:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $246
c01027bc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027c1:	e9 6c 00 00 00       	jmp    c0102832 <__alltraps>

c01027c6 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $247
c01027c8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027cd:	e9 60 00 00 00       	jmp    c0102832 <__alltraps>

c01027d2 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $248
c01027d4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027d9:	e9 54 00 00 00       	jmp    c0102832 <__alltraps>

c01027de <vector249>:
.globl vector249
vector249:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $249
c01027e0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027e5:	e9 48 00 00 00       	jmp    c0102832 <__alltraps>

c01027ea <vector250>:
.globl vector250
vector250:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $250
c01027ec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027f1:	e9 3c 00 00 00       	jmp    c0102832 <__alltraps>

c01027f6 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $251
c01027f8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027fd:	e9 30 00 00 00       	jmp    c0102832 <__alltraps>

c0102802 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $252
c0102804:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102809:	e9 24 00 00 00       	jmp    c0102832 <__alltraps>

c010280e <vector253>:
.globl vector253
vector253:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $253
c0102810:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102815:	e9 18 00 00 00       	jmp    c0102832 <__alltraps>

c010281a <vector254>:
.globl vector254
vector254:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $254
c010281c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102821:	e9 0c 00 00 00       	jmp    c0102832 <__alltraps>

c0102826 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $255
c0102828:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010282d:	e9 00 00 00 00       	jmp    c0102832 <__alltraps>

c0102832 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102832:	1e                   	push   %ds
    pushl %es
c0102833:	06                   	push   %es
    pushl %fs
c0102834:	0f a0                	push   %fs
    pushl %gs
c0102836:	0f a8                	push   %gs
    pushal
c0102838:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102839:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010283e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102840:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102842:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102843:	e8 63 f5 ff ff       	call   c0101dab <trap>

    # pop the pushed stack pointer
    popl %esp
c0102848:	5c                   	pop    %esp

c0102849 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102849:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010284a:	0f a9                	pop    %gs
    popl %fs
c010284c:	0f a1                	pop    %fs
    popl %es
c010284e:	07                   	pop    %es
    popl %ds
c010284f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102850:	83 c4 08             	add    $0x8,%esp
    iret
c0102853:	cf                   	iret   

c0102854 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102854:	55                   	push   %ebp
c0102855:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102857:	8b 45 08             	mov    0x8(%ebp),%eax
c010285a:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102860:	29 d0                	sub    %edx,%eax
c0102862:	c1 f8 02             	sar    $0x2,%eax
c0102865:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010286b:	5d                   	pop    %ebp
c010286c:	c3                   	ret    

c010286d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010286d:	55                   	push   %ebp
c010286e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102870:	ff 75 08             	pushl  0x8(%ebp)
c0102873:	e8 dc ff ff ff       	call   c0102854 <page2ppn>
c0102878:	83 c4 04             	add    $0x4,%esp
c010287b:	c1 e0 0c             	shl    $0xc,%eax
}
c010287e:	c9                   	leave  
c010287f:	c3                   	ret    

c0102880 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102880:	55                   	push   %ebp
c0102881:	89 e5                	mov    %esp,%ebp
c0102883:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102886:	8b 45 08             	mov    0x8(%ebp),%eax
c0102889:	c1 e8 0c             	shr    $0xc,%eax
c010288c:	89 c2                	mov    %eax,%edx
c010288e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102893:	39 c2                	cmp    %eax,%edx
c0102895:	72 14                	jb     c01028ab <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102897:	83 ec 04             	sub    $0x4,%esp
c010289a:	68 50 65 10 c0       	push   $0xc0106550
c010289f:	6a 5a                	push   $0x5a
c01028a1:	68 6f 65 10 c0       	push   $0xc010656f
c01028a6:	e8 22 db ff ff       	call   c01003cd <__panic>
    }
    return &pages[PPN(pa)];
c01028ab:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c01028b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b4:	c1 e8 0c             	shr    $0xc,%eax
c01028b7:	89 c2                	mov    %eax,%edx
c01028b9:	89 d0                	mov    %edx,%eax
c01028bb:	c1 e0 02             	shl    $0x2,%eax
c01028be:	01 d0                	add    %edx,%eax
c01028c0:	c1 e0 02             	shl    $0x2,%eax
c01028c3:	01 c8                	add    %ecx,%eax
}
c01028c5:	c9                   	leave  
c01028c6:	c3                   	ret    

c01028c7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01028c7:	55                   	push   %ebp
c01028c8:	89 e5                	mov    %esp,%ebp
c01028ca:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01028cd:	ff 75 08             	pushl  0x8(%ebp)
c01028d0:	e8 98 ff ff ff       	call   c010286d <page2pa>
c01028d5:	83 c4 04             	add    $0x4,%esp
c01028d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028de:	c1 e8 0c             	shr    $0xc,%eax
c01028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01028e4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01028e9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01028ec:	72 14                	jb     c0102902 <page2kva+0x3b>
c01028ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01028f1:	68 80 65 10 c0       	push   $0xc0106580
c01028f6:	6a 61                	push   $0x61
c01028f8:	68 6f 65 10 c0       	push   $0xc010656f
c01028fd:	e8 cb da ff ff       	call   c01003cd <__panic>
c0102902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102905:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010290a:	c9                   	leave  
c010290b:	c3                   	ret    

c010290c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010290c:	55                   	push   %ebp
c010290d:	89 e5                	mov    %esp,%ebp
c010290f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102912:	8b 45 08             	mov    0x8(%ebp),%eax
c0102915:	83 e0 01             	and    $0x1,%eax
c0102918:	85 c0                	test   %eax,%eax
c010291a:	75 14                	jne    c0102930 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010291c:	83 ec 04             	sub    $0x4,%esp
c010291f:	68 a4 65 10 c0       	push   $0xc01065a4
c0102924:	6a 6c                	push   $0x6c
c0102926:	68 6f 65 10 c0       	push   $0xc010656f
c010292b:	e8 9d da ff ff       	call   c01003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102930:	8b 45 08             	mov    0x8(%ebp),%eax
c0102933:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102938:	83 ec 0c             	sub    $0xc,%esp
c010293b:	50                   	push   %eax
c010293c:	e8 3f ff ff ff       	call   c0102880 <pa2page>
c0102941:	83 c4 10             	add    $0x10,%esp
}
c0102944:	c9                   	leave  
c0102945:	c3                   	ret    

c0102946 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102946:	55                   	push   %ebp
c0102947:	89 e5                	mov    %esp,%ebp
c0102949:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010294c:	8b 45 08             	mov    0x8(%ebp),%eax
c010294f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102954:	83 ec 0c             	sub    $0xc,%esp
c0102957:	50                   	push   %eax
c0102958:	e8 23 ff ff ff       	call   c0102880 <pa2page>
c010295d:	83 c4 10             	add    $0x10,%esp
}
c0102960:	c9                   	leave  
c0102961:	c3                   	ret    

c0102962 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102962:	55                   	push   %ebp
c0102963:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102965:	8b 45 08             	mov    0x8(%ebp),%eax
c0102968:	8b 00                	mov    (%eax),%eax
}
c010296a:	5d                   	pop    %ebp
c010296b:	c3                   	ret    

c010296c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010296c:	55                   	push   %ebp
c010296d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010296f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102972:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102975:	89 10                	mov    %edx,(%eax)
}
c0102977:	90                   	nop
c0102978:	5d                   	pop    %ebp
c0102979:	c3                   	ret    

c010297a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010297a:	55                   	push   %ebp
c010297b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010297d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102980:	8b 00                	mov    (%eax),%eax
c0102982:	8d 50 01             	lea    0x1(%eax),%edx
c0102985:	8b 45 08             	mov    0x8(%ebp),%eax
c0102988:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010298a:	8b 45 08             	mov    0x8(%ebp),%eax
c010298d:	8b 00                	mov    (%eax),%eax
}
c010298f:	5d                   	pop    %ebp
c0102990:	c3                   	ret    

c0102991 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102991:	55                   	push   %ebp
c0102992:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102994:	8b 45 08             	mov    0x8(%ebp),%eax
c0102997:	8b 00                	mov    (%eax),%eax
c0102999:	8d 50 ff             	lea    -0x1(%eax),%edx
c010299c:	8b 45 08             	mov    0x8(%ebp),%eax
c010299f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a4:	8b 00                	mov    (%eax),%eax
}
c01029a6:	5d                   	pop    %ebp
c01029a7:	c3                   	ret    

c01029a8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01029a8:	55                   	push   %ebp
c01029a9:	89 e5                	mov    %esp,%ebp
c01029ab:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029ae:	9c                   	pushf  
c01029af:	58                   	pop    %eax
c01029b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029b6:	25 00 02 00 00       	and    $0x200,%eax
c01029bb:	85 c0                	test   %eax,%eax
c01029bd:	74 0c                	je     c01029cb <__intr_save+0x23>
        intr_disable();
c01029bf:	e8 9b ee ff ff       	call   c010185f <intr_disable>
        return 1;
c01029c4:	b8 01 00 00 00       	mov    $0x1,%eax
c01029c9:	eb 05                	jmp    c01029d0 <__intr_save+0x28>
    }
    return 0;
c01029cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01029d0:	c9                   	leave  
c01029d1:	c3                   	ret    

c01029d2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01029d2:	55                   	push   %ebp
c01029d3:	89 e5                	mov    %esp,%ebp
c01029d5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01029d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029dc:	74 05                	je     c01029e3 <__intr_restore+0x11>
        intr_enable();
c01029de:	e8 75 ee ff ff       	call   c0101858 <intr_enable>
    }
}
c01029e3:	90                   	nop
c01029e4:	c9                   	leave  
c01029e5:	c3                   	ret    

c01029e6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01029e6:	55                   	push   %ebp
c01029e7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01029e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ec:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01029ef:	b8 23 00 00 00       	mov    $0x23,%eax
c01029f4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01029f6:	b8 23 00 00 00       	mov    $0x23,%eax
c01029fb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01029fd:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a02:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a04:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a09:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a0b:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a10:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a12:	ea 19 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a19
}
c0102a19:	90                   	nop
c0102a1a:	5d                   	pop    %ebp
c0102a1b:	c3                   	ret    

c0102a1c <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a1c:	55                   	push   %ebp
c0102a1d:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a22:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102a27:	90                   	nop
c0102a28:	5d                   	pop    %ebp
c0102a29:	c3                   	ret    

c0102a2a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a2a:	55                   	push   %ebp
c0102a2b:	89 e5                	mov    %esp,%ebp
c0102a2d:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a30:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a35:	50                   	push   %eax
c0102a36:	e8 e1 ff ff ff       	call   c0102a1c <load_esp0>
c0102a3b:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102a3e:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102a45:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a47:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a4e:	68 00 
c0102a50:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a55:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a5b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a60:	c1 e8 10             	shr    $0x10,%eax
c0102a63:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a68:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a6f:	83 e0 f0             	and    $0xfffffff0,%eax
c0102a72:	83 c8 09             	or     $0x9,%eax
c0102a75:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a7a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a81:	83 e0 ef             	and    $0xffffffef,%eax
c0102a84:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a89:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a90:	83 e0 9f             	and    $0xffffff9f,%eax
c0102a93:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a98:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a9f:	83 c8 80             	or     $0xffffff80,%eax
c0102aa2:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102aa7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aae:	83 e0 f0             	and    $0xfffffff0,%eax
c0102ab1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ab6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102abd:	83 e0 ef             	and    $0xffffffef,%eax
c0102ac0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ac5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102acc:	83 e0 df             	and    $0xffffffdf,%eax
c0102acf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ad4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102adb:	83 c8 40             	or     $0x40,%eax
c0102ade:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ae3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aea:	83 e0 7f             	and    $0x7f,%eax
c0102aed:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102af2:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102af7:	c1 e8 18             	shr    $0x18,%eax
c0102afa:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102aff:	68 30 7a 11 c0       	push   $0xc0117a30
c0102b04:	e8 dd fe ff ff       	call   c01029e6 <lgdt>
c0102b09:	83 c4 04             	add    $0x4,%esp
c0102b0c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b12:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b16:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b19:	90                   	nop
c0102b1a:	c9                   	leave  
c0102b1b:	c3                   	ret    

c0102b1c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b1c:	55                   	push   %ebp
c0102b1d:	89 e5                	mov    %esp,%ebp
c0102b1f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b22:	c7 05 50 89 11 c0 dc 	movl   $0xc0106fdc,0xc0118950
c0102b29:	6f 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b2c:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b31:	8b 00                	mov    (%eax),%eax
c0102b33:	83 ec 08             	sub    $0x8,%esp
c0102b36:	50                   	push   %eax
c0102b37:	68 d0 65 10 c0       	push   $0xc01065d0
c0102b3c:	e8 26 d7 ff ff       	call   c0100267 <cprintf>
c0102b41:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102b44:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b49:	8b 40 04             	mov    0x4(%eax),%eax
c0102b4c:	ff d0                	call   *%eax
}
c0102b4e:	90                   	nop
c0102b4f:	c9                   	leave  
c0102b50:	c3                   	ret    

c0102b51 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b51:	55                   	push   %ebp
c0102b52:	89 e5                	mov    %esp,%ebp
c0102b54:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102b57:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b5c:	8b 40 08             	mov    0x8(%eax),%eax
c0102b5f:	83 ec 08             	sub    $0x8,%esp
c0102b62:	ff 75 0c             	pushl  0xc(%ebp)
c0102b65:	ff 75 08             	pushl  0x8(%ebp)
c0102b68:	ff d0                	call   *%eax
c0102b6a:	83 c4 10             	add    $0x10,%esp
}
c0102b6d:	90                   	nop
c0102b6e:	c9                   	leave  
c0102b6f:	c3                   	ret    

c0102b70 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102b70:	55                   	push   %ebp
c0102b71:	89 e5                	mov    %esp,%ebp
c0102b73:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102b76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b7d:	e8 26 fe ff ff       	call   c01029a8 <__intr_save>
c0102b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102b85:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b8a:	8b 40 0c             	mov    0xc(%eax),%eax
c0102b8d:	83 ec 0c             	sub    $0xc,%esp
c0102b90:	ff 75 08             	pushl  0x8(%ebp)
c0102b93:	ff d0                	call   *%eax
c0102b95:	83 c4 10             	add    $0x10,%esp
c0102b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102b9b:	83 ec 0c             	sub    $0xc,%esp
c0102b9e:	ff 75 f0             	pushl  -0x10(%ebp)
c0102ba1:	e8 2c fe ff ff       	call   c01029d2 <__intr_restore>
c0102ba6:	83 c4 10             	add    $0x10,%esp
    return page;
c0102ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bac:	c9                   	leave  
c0102bad:	c3                   	ret    

c0102bae <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102bae:	55                   	push   %ebp
c0102baf:	89 e5                	mov    %esp,%ebp
c0102bb1:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bb4:	e8 ef fd ff ff       	call   c01029a8 <__intr_save>
c0102bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102bbc:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bc1:	8b 40 10             	mov    0x10(%eax),%eax
c0102bc4:	83 ec 08             	sub    $0x8,%esp
c0102bc7:	ff 75 0c             	pushl  0xc(%ebp)
c0102bca:	ff 75 08             	pushl  0x8(%ebp)
c0102bcd:	ff d0                	call   *%eax
c0102bcf:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102bd2:	83 ec 0c             	sub    $0xc,%esp
c0102bd5:	ff 75 f4             	pushl  -0xc(%ebp)
c0102bd8:	e8 f5 fd ff ff       	call   c01029d2 <__intr_restore>
c0102bdd:	83 c4 10             	add    $0x10,%esp
}
c0102be0:	90                   	nop
c0102be1:	c9                   	leave  
c0102be2:	c3                   	ret    

c0102be3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102be3:	55                   	push   %ebp
c0102be4:	89 e5                	mov    %esp,%ebp
c0102be6:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102be9:	e8 ba fd ff ff       	call   c01029a8 <__intr_save>
c0102bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102bf1:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bf6:	8b 40 14             	mov    0x14(%eax),%eax
c0102bf9:	ff d0                	call   *%eax
c0102bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102bfe:	83 ec 0c             	sub    $0xc,%esp
c0102c01:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c04:	e8 c9 fd ff ff       	call   c01029d2 <__intr_restore>
c0102c09:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c0f:	c9                   	leave  
c0102c10:	c3                   	ret    

c0102c11 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c11:	55                   	push   %ebp
c0102c12:	89 e5                	mov    %esp,%ebp
c0102c14:	57                   	push   %edi
c0102c15:	56                   	push   %esi
c0102c16:	53                   	push   %ebx
c0102c17:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c1a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c21:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c2f:	83 ec 0c             	sub    $0xc,%esp
c0102c32:	68 e7 65 10 c0       	push   $0xc01065e7
c0102c37:	e8 2b d6 ff ff       	call   c0100267 <cprintf>
c0102c3c:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c46:	e9 fc 00 00 00       	jmp    c0102d47 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c51:	89 d0                	mov    %edx,%eax
c0102c53:	c1 e0 02             	shl    $0x2,%eax
c0102c56:	01 d0                	add    %edx,%eax
c0102c58:	c1 e0 02             	shl    $0x2,%eax
c0102c5b:	01 c8                	add    %ecx,%eax
c0102c5d:	8b 50 08             	mov    0x8(%eax),%edx
c0102c60:	8b 40 04             	mov    0x4(%eax),%eax
c0102c63:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102c66:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102c69:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c6f:	89 d0                	mov    %edx,%eax
c0102c71:	c1 e0 02             	shl    $0x2,%eax
c0102c74:	01 d0                	add    %edx,%eax
c0102c76:	c1 e0 02             	shl    $0x2,%eax
c0102c79:	01 c8                	add    %ecx,%eax
c0102c7b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c7e:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c81:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c84:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c87:	01 c8                	add    %ecx,%eax
c0102c89:	11 da                	adc    %ebx,%edx
c0102c8b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102c8e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102c91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c94:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c97:	89 d0                	mov    %edx,%eax
c0102c99:	c1 e0 02             	shl    $0x2,%eax
c0102c9c:	01 d0                	add    %edx,%eax
c0102c9e:	c1 e0 02             	shl    $0x2,%eax
c0102ca1:	01 c8                	add    %ecx,%eax
c0102ca3:	83 c0 14             	add    $0x14,%eax
c0102ca6:	8b 00                	mov    (%eax),%eax
c0102ca8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102cab:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102cae:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102cb1:	83 c0 ff             	add    $0xffffffff,%eax
c0102cb4:	83 d2 ff             	adc    $0xffffffff,%edx
c0102cb7:	89 c1                	mov    %eax,%ecx
c0102cb9:	89 d3                	mov    %edx,%ebx
c0102cbb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cbe:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102cc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cc4:	89 d0                	mov    %edx,%eax
c0102cc6:	c1 e0 02             	shl    $0x2,%eax
c0102cc9:	01 d0                	add    %edx,%eax
c0102ccb:	c1 e0 02             	shl    $0x2,%eax
c0102cce:	03 45 80             	add    -0x80(%ebp),%eax
c0102cd1:	8b 50 10             	mov    0x10(%eax),%edx
c0102cd4:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cd7:	ff 75 84             	pushl  -0x7c(%ebp)
c0102cda:	53                   	push   %ebx
c0102cdb:	51                   	push   %ecx
c0102cdc:	ff 75 bc             	pushl  -0x44(%ebp)
c0102cdf:	ff 75 b8             	pushl  -0x48(%ebp)
c0102ce2:	52                   	push   %edx
c0102ce3:	50                   	push   %eax
c0102ce4:	68 f4 65 10 c0       	push   $0xc01065f4
c0102ce9:	e8 79 d5 ff ff       	call   c0100267 <cprintf>
c0102cee:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102cf1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cf4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cf7:	89 d0                	mov    %edx,%eax
c0102cf9:	c1 e0 02             	shl    $0x2,%eax
c0102cfc:	01 d0                	add    %edx,%eax
c0102cfe:	c1 e0 02             	shl    $0x2,%eax
c0102d01:	01 c8                	add    %ecx,%eax
c0102d03:	83 c0 14             	add    $0x14,%eax
c0102d06:	8b 00                	mov    (%eax),%eax
c0102d08:	83 f8 01             	cmp    $0x1,%eax
c0102d0b:	75 36                	jne    c0102d43 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d13:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d16:	77 2b                	ja     c0102d43 <page_init+0x132>
c0102d18:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d1b:	72 05                	jb     c0102d22 <page_init+0x111>
c0102d1d:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d20:	73 21                	jae    c0102d43 <page_init+0x132>
c0102d22:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d26:	77 1b                	ja     c0102d43 <page_init+0x132>
c0102d28:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d2c:	72 09                	jb     c0102d37 <page_init+0x126>
c0102d2e:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102d35:	77 0c                	ja     c0102d43 <page_init+0x132>
                maxpa = end;
c0102d37:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d3a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d40:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d43:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d4a:	8b 00                	mov    (%eax),%eax
c0102d4c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102d4f:	0f 8f f6 fe ff ff    	jg     c0102c4b <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d59:	72 1d                	jb     c0102d78 <page_init+0x167>
c0102d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d5f:	77 09                	ja     c0102d6a <page_init+0x159>
c0102d61:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d68:	76 0e                	jbe    c0102d78 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102d6a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102d71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d7e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d82:	c1 ea 0c             	shr    $0xc,%edx
c0102d85:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102d8a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102d91:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102d96:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d99:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d9c:	01 d0                	add    %edx,%eax
c0102d9e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102da1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102da4:	ba 00 00 00 00       	mov    $0x0,%edx
c0102da9:	f7 75 ac             	divl   -0x54(%ebp)
c0102dac:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102daf:	29 d0                	sub    %edx,%eax
c0102db1:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    
    for (i = 0; i < npage; i ++) {
c0102db6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dbd:	eb 2f                	jmp    c0102dee <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102dbf:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dc8:	89 d0                	mov    %edx,%eax
c0102dca:	c1 e0 02             	shl    $0x2,%eax
c0102dcd:	01 d0                	add    %edx,%eax
c0102dcf:	c1 e0 02             	shl    $0x2,%eax
c0102dd2:	01 c8                	add    %ecx,%eax
c0102dd4:	83 c0 04             	add    $0x4,%eax
c0102dd7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102dde:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102de1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102de4:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102de7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    
    for (i = 0; i < npage; i ++) {
c0102dea:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102df1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102df6:	39 c2                	cmp    %eax,%edx
c0102df8:	72 c5                	jb     c0102dbf <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102dfa:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102e00:	89 d0                	mov    %edx,%eax
c0102e02:	c1 e0 02             	shl    $0x2,%eax
c0102e05:	01 d0                	add    %edx,%eax
c0102e07:	c1 e0 02             	shl    $0x2,%eax
c0102e0a:	89 c2                	mov    %eax,%edx
c0102e0c:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e11:	01 d0                	add    %edx,%eax
c0102e13:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e16:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e1d:	77 17                	ja     c0102e36 <page_init+0x225>
c0102e1f:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e22:	68 24 66 10 c0       	push   $0xc0106624
c0102e27:	68 db 00 00 00       	push   $0xdb
c0102e2c:	68 48 66 10 c0       	push   $0xc0106648
c0102e31:	e8 97 d5 ff ff       	call   c01003cd <__panic>
c0102e36:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e39:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e3e:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e48:	e9 69 01 00 00       	jmp    c0102fb6 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e53:	89 d0                	mov    %edx,%eax
c0102e55:	c1 e0 02             	shl    $0x2,%eax
c0102e58:	01 d0                	add    %edx,%eax
c0102e5a:	c1 e0 02             	shl    $0x2,%eax
c0102e5d:	01 c8                	add    %ecx,%eax
c0102e5f:	8b 50 08             	mov    0x8(%eax),%edx
c0102e62:	8b 40 04             	mov    0x4(%eax),%eax
c0102e65:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e68:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e71:	89 d0                	mov    %edx,%eax
c0102e73:	c1 e0 02             	shl    $0x2,%eax
c0102e76:	01 d0                	add    %edx,%eax
c0102e78:	c1 e0 02             	shl    $0x2,%eax
c0102e7b:	01 c8                	add    %ecx,%eax
c0102e7d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e80:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e83:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102e89:	01 c8                	add    %ecx,%eax
c0102e8b:	11 da                	adc    %ebx,%edx
c0102e8d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102e90:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102e93:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e96:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e99:	89 d0                	mov    %edx,%eax
c0102e9b:	c1 e0 02             	shl    $0x2,%eax
c0102e9e:	01 d0                	add    %edx,%eax
c0102ea0:	c1 e0 02             	shl    $0x2,%eax
c0102ea3:	01 c8                	add    %ecx,%eax
c0102ea5:	83 c0 14             	add    $0x14,%eax
c0102ea8:	8b 00                	mov    (%eax),%eax
c0102eaa:	83 f8 01             	cmp    $0x1,%eax
c0102ead:	0f 85 ff 00 00 00    	jne    c0102fb2 <page_init+0x3a1>
            if (begin < freemem) {
c0102eb3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102eb6:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ebb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102ebe:	72 17                	jb     c0102ed7 <page_init+0x2c6>
c0102ec0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102ec3:	77 05                	ja     c0102eca <page_init+0x2b9>
c0102ec5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102ec8:	76 0d                	jbe    c0102ed7 <page_init+0x2c6>
                begin = freemem;
c0102eca:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ecd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ed0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ed7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102edb:	72 1d                	jb     c0102efa <page_init+0x2e9>
c0102edd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ee1:	77 09                	ja     c0102eec <page_init+0x2db>
c0102ee3:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102eea:	76 0e                	jbe    c0102efa <page_init+0x2e9>
                end = KMEMSIZE;
c0102eec:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102ef3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102efa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102efd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f00:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f03:	0f 87 a9 00 00 00    	ja     c0102fb2 <page_init+0x3a1>
c0102f09:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f0c:	72 09                	jb     c0102f17 <page_init+0x306>
c0102f0e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f11:	0f 83 9b 00 00 00    	jae    c0102fb2 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f17:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f1e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f21:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f24:	01 d0                	add    %edx,%eax
c0102f26:	83 e8 01             	sub    $0x1,%eax
c0102f29:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f2c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f2f:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f34:	f7 75 9c             	divl   -0x64(%ebp)
c0102f37:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f3a:	29 d0                	sub    %edx,%eax
c0102f3c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f41:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f47:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f4a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f4d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f50:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f55:	89 c3                	mov    %eax,%ebx
c0102f57:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f5d:	89 de                	mov    %ebx,%esi
c0102f5f:	89 d0                	mov    %edx,%eax
c0102f61:	83 e0 00             	and    $0x0,%eax
c0102f64:	89 c7                	mov    %eax,%edi
c0102f66:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f69:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102f6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f72:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f75:	77 3b                	ja     c0102fb2 <page_init+0x3a1>
c0102f77:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f7a:	72 05                	jb     c0102f81 <page_init+0x370>
c0102f7c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f7f:	73 31                	jae    c0102fb2 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102f81:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f84:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f87:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102f8a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102f8d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f91:	c1 ea 0c             	shr    $0xc,%edx
c0102f94:	89 c3                	mov    %eax,%ebx
c0102f96:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f99:	83 ec 0c             	sub    $0xc,%esp
c0102f9c:	50                   	push   %eax
c0102f9d:	e8 de f8 ff ff       	call   c0102880 <pa2page>
c0102fa2:	83 c4 10             	add    $0x10,%esp
c0102fa5:	83 ec 08             	sub    $0x8,%esp
c0102fa8:	53                   	push   %ebx
c0102fa9:	50                   	push   %eax
c0102faa:	e8 a2 fb ff ff       	call   c0102b51 <init_memmap>
c0102faf:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0102fb2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fb6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fb9:	8b 00                	mov    (%eax),%eax
c0102fbb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102fbe:	0f 8f 89 fe ff ff    	jg     c0102e4d <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0102fc4:	90                   	nop
c0102fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102fc8:	5b                   	pop    %ebx
c0102fc9:	5e                   	pop    %esi
c0102fca:	5f                   	pop    %edi
c0102fcb:	5d                   	pop    %ebp
c0102fcc:	c3                   	ret    

c0102fcd <enable_paging>:

static void
enable_paging(void) {
c0102fcd:	55                   	push   %ebp
c0102fce:	89 e5                	mov    %esp,%ebp
c0102fd0:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0102fd3:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0102fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0102fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102fde:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0102fe1:	0f 20 c0             	mov    %cr0,%eax
c0102fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0102fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0102fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0102fed:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0102ff4:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0102ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0102ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103001:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103004:	90                   	nop
c0103005:	c9                   	leave  
c0103006:	c3                   	ret    

c0103007 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103007:	55                   	push   %ebp
c0103008:	89 e5                	mov    %esp,%ebp
c010300a:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010300d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103010:	33 45 14             	xor    0x14(%ebp),%eax
c0103013:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103018:	85 c0                	test   %eax,%eax
c010301a:	74 19                	je     c0103035 <boot_map_segment+0x2e>
c010301c:	68 56 66 10 c0       	push   $0xc0106656
c0103021:	68 6d 66 10 c0       	push   $0xc010666d
c0103026:	68 04 01 00 00       	push   $0x104
c010302b:	68 48 66 10 c0       	push   $0xc0106648
c0103030:	e8 98 d3 ff ff       	call   c01003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103035:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010303c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010303f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103044:	89 c2                	mov    %eax,%edx
c0103046:	8b 45 10             	mov    0x10(%ebp),%eax
c0103049:	01 c2                	add    %eax,%edx
c010304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010304e:	01 d0                	add    %edx,%eax
c0103050:	83 e8 01             	sub    $0x1,%eax
c0103053:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103056:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103059:	ba 00 00 00 00       	mov    $0x0,%edx
c010305e:	f7 75 f0             	divl   -0x10(%ebp)
c0103061:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103064:	29 d0                	sub    %edx,%eax
c0103066:	c1 e8 0c             	shr    $0xc,%eax
c0103069:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010306c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010306f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103072:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010307a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010307d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010308b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010308e:	eb 57                	jmp    c01030e7 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103090:	83 ec 04             	sub    $0x4,%esp
c0103093:	6a 01                	push   $0x1
c0103095:	ff 75 0c             	pushl  0xc(%ebp)
c0103098:	ff 75 08             	pushl  0x8(%ebp)
c010309b:	e8 98 01 00 00       	call   c0103238 <get_pte>
c01030a0:	83 c4 10             	add    $0x10,%esp
c01030a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01030a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01030aa:	75 19                	jne    c01030c5 <boot_map_segment+0xbe>
c01030ac:	68 82 66 10 c0       	push   $0xc0106682
c01030b1:	68 6d 66 10 c0       	push   $0xc010666d
c01030b6:	68 0a 01 00 00       	push   $0x10a
c01030bb:	68 48 66 10 c0       	push   $0xc0106648
c01030c0:	e8 08 d3 ff ff       	call   c01003cd <__panic>
        *ptep = pa | PTE_P | perm;
c01030c5:	8b 45 14             	mov    0x14(%ebp),%eax
c01030c8:	0b 45 18             	or     0x18(%ebp),%eax
c01030cb:	83 c8 01             	or     $0x1,%eax
c01030ce:	89 c2                	mov    %eax,%edx
c01030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030d3:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01030d9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01030e0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030eb:	75 a3                	jne    c0103090 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01030ed:	90                   	nop
c01030ee:	c9                   	leave  
c01030ef:	c3                   	ret    

c01030f0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01030f0:	55                   	push   %ebp
c01030f1:	89 e5                	mov    %esp,%ebp
c01030f3:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01030f6:	83 ec 0c             	sub    $0xc,%esp
c01030f9:	6a 01                	push   $0x1
c01030fb:	e8 70 fa ff ff       	call   c0102b70 <alloc_pages>
c0103100:	83 c4 10             	add    $0x10,%esp
c0103103:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010310a:	75 17                	jne    c0103123 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010310c:	83 ec 04             	sub    $0x4,%esp
c010310f:	68 8f 66 10 c0       	push   $0xc010668f
c0103114:	68 16 01 00 00       	push   $0x116
c0103119:	68 48 66 10 c0       	push   $0xc0106648
c010311e:	e8 aa d2 ff ff       	call   c01003cd <__panic>
    }
    return page2kva(p);
c0103123:	83 ec 0c             	sub    $0xc,%esp
c0103126:	ff 75 f4             	pushl  -0xc(%ebp)
c0103129:	e8 99 f7 ff ff       	call   c01028c7 <page2kva>
c010312e:	83 c4 10             	add    $0x10,%esp
}
c0103131:	c9                   	leave  
c0103132:	c3                   	ret    

c0103133 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103133:	55                   	push   %ebp
c0103134:	89 e5                	mov    %esp,%ebp
c0103136:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103139:	e8 de f9 ff ff       	call   c0102b1c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010313e:	e8 ce fa ff ff       	call   c0102c11 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103143:	e8 48 05 00 00       	call   c0103690 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103148:	e8 a3 ff ff ff       	call   c01030f0 <boot_alloc_page>
c010314d:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103152:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103157:	83 ec 04             	sub    $0x4,%esp
c010315a:	68 00 10 00 00       	push   $0x1000
c010315f:	6a 00                	push   $0x0
c0103161:	50                   	push   %eax
c0103162:	e8 2f 25 00 00       	call   c0105696 <memset>
c0103167:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c010316a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010316f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103172:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103179:	77 17                	ja     c0103192 <pmm_init+0x5f>
c010317b:	ff 75 f4             	pushl  -0xc(%ebp)
c010317e:	68 24 66 10 c0       	push   $0xc0106624
c0103183:	68 30 01 00 00       	push   $0x130
c0103188:	68 48 66 10 c0       	push   $0xc0106648
c010318d:	e8 3b d2 ff ff       	call   c01003cd <__panic>
c0103192:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103195:	05 00 00 00 40       	add    $0x40000000,%eax
c010319a:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c010319f:	e8 0f 05 00 00       	call   c01036b3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01031a4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031a9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01031af:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031b7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01031be:	77 17                	ja     c01031d7 <pmm_init+0xa4>
c01031c0:	ff 75 f0             	pushl  -0x10(%ebp)
c01031c3:	68 24 66 10 c0       	push   $0xc0106624
c01031c8:	68 38 01 00 00       	push   $0x138
c01031cd:	68 48 66 10 c0       	push   $0xc0106648
c01031d2:	e8 f6 d1 ff ff       	call   c01003cd <__panic>
c01031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031da:	05 00 00 00 40       	add    $0x40000000,%eax
c01031df:	83 c8 03             	or     $0x3,%eax
c01031e2:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01031e4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031e9:	83 ec 0c             	sub    $0xc,%esp
c01031ec:	6a 02                	push   $0x2
c01031ee:	6a 00                	push   $0x0
c01031f0:	68 00 00 00 38       	push   $0x38000000
c01031f5:	68 00 00 00 c0       	push   $0xc0000000
c01031fa:	50                   	push   %eax
c01031fb:	e8 07 fe ff ff       	call   c0103007 <boot_map_segment>
c0103200:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103203:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103208:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010320e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103214:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103216:	e8 b2 fd ff ff       	call   c0102fcd <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010321b:	e8 0a f8 ff ff       	call   c0102a2a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103220:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103225:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010322b:	e8 e9 09 00 00       	call   c0103c19 <check_boot_pgdir>

    print_pgdir();
c0103230:	e8 df 0d 00 00       	call   c0104014 <print_pgdir>

}
c0103235:	90                   	nop
c0103236:	c9                   	leave  
c0103237:	c3                   	ret    

c0103238 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte( pde_t *pgdir, uintptr_t la, bool create ) 
{
c0103238:	55                   	push   %ebp
c0103239:	89 e5                	mov    %esp,%ebp
c010323b:	83 ec 38             	sub    $0x38,%esp
    //
    
    uintptr_t pdx, ptx, pt_pa;
    struct Page *new_page_table; 
    
    pdx = PDX( la );
c010323e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103241:	c1 e8 16             	shr    $0x16,%eax
c0103244:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ptx = PTX( la );
c0103247:	8b 45 0c             	mov    0xc(%ebp),%eax
c010324a:	c1 e8 0c             	shr    $0xc,%eax
c010324d:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103252:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if( pgdir[ pdx ] & PTE_P )
c0103255:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010325f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103262:	01 d0                	add    %edx,%eax
c0103264:	8b 00                	mov    (%eax),%eax
c0103266:	83 e0 01             	and    $0x1,%eax
c0103269:	85 c0                	test   %eax,%eax
c010326b:	74 5a                	je     c01032c7 <get_pte+0x8f>
        return &( ( pte_t * )( KADDR( PDE_ADDR( pgdir[ pdx ] ) ) ) )[ ptx ]; 
c010326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103277:	8b 45 08             	mov    0x8(%ebp),%eax
c010327a:	01 d0                	add    %edx,%eax
c010327c:	8b 00                	mov    (%eax),%eax
c010327e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103283:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103286:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103289:	c1 e8 0c             	shr    $0xc,%eax
c010328c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010328f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103294:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103297:	72 17                	jb     c01032b0 <get_pte+0x78>
c0103299:	ff 75 ec             	pushl  -0x14(%ebp)
c010329c:	68 80 65 10 c0       	push   $0xc0106580
c01032a1:	68 86 01 00 00       	push   $0x186
c01032a6:	68 48 66 10 c0       	push   $0xc0106648
c01032ab:	e8 1d d1 ff ff       	call   c01003cd <__panic>
c01032b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032b3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01032b8:	89 c2                	mov    %eax,%edx
c01032ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032bd:	c1 e0 02             	shl    $0x2,%eax
c01032c0:	01 d0                	add    %edx,%eax
c01032c2:	e9 a2 01 00 00       	jmp    c0103469 <get_pte+0x231>
    else
    {
        if( 0 == create )
c01032c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01032cb:	75 0a                	jne    c01032d7 <get_pte+0x9f>
            return NULL;
c01032cd:	b8 00 00 00 00       	mov    $0x0,%eax
c01032d2:	e9 92 01 00 00       	jmp    c0103469 <get_pte+0x231>
        else
        {
            cprintf( "\n\npages = %08x\n\n",pages );
c01032d7:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032dc:	83 ec 08             	sub    $0x8,%esp
c01032df:	50                   	push   %eax
c01032e0:	68 a8 66 10 c0       	push   $0xc01066a8
c01032e5:	e8 7d cf ff ff       	call   c0100267 <cprintf>
c01032ea:	83 c4 10             	add    $0x10,%esp
            new_page_table = alloc_page();
c01032ed:	83 ec 0c             	sub    $0xc,%esp
c01032f0:	6a 01                	push   $0x1
c01032f2:	e8 79 f8 ff ff       	call   c0102b70 <alloc_pages>
c01032f7:	83 c4 10             	add    $0x10,%esp
c01032fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            cprintf("new_page_table - pages = 0x%08x\n", new_page_table - pages );
c01032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103300:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0103306:	29 d0                	sub    %edx,%eax
c0103308:	c1 f8 02             	sar    $0x2,%eax
c010330b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c0103311:	83 ec 08             	sub    $0x8,%esp
c0103314:	50                   	push   %eax
c0103315:	68 bc 66 10 c0       	push   $0xc01066bc
c010331a:	e8 48 cf ff ff       	call   c0100267 <cprintf>
c010331f:	83 c4 10             	add    $0x10,%esp
            cprintf("new_page_table = 0x%08x\n", new_page_table);
c0103322:	83 ec 08             	sub    $0x8,%esp
c0103325:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103328:	68 dd 66 10 c0       	push   $0xc01066dd
c010332d:	e8 35 cf ff ff       	call   c0100267 <cprintf>
c0103332:	83 c4 10             	add    $0x10,%esp
            set_page_ref( new_page_table, 1 ); 
c0103335:	83 ec 08             	sub    $0x8,%esp
c0103338:	6a 01                	push   $0x1
c010333a:	ff 75 e4             	pushl  -0x1c(%ebp)
c010333d:	e8 2a f6 ff ff       	call   c010296c <set_page_ref>
c0103342:	83 c4 10             	add    $0x10,%esp
            pt_pa = page2pa( new_page_table );
c0103345:	83 ec 0c             	sub    $0xc,%esp
c0103348:	ff 75 e4             	pushl  -0x1c(%ebp)
c010334b:	e8 1d f5 ff ff       	call   c010286d <page2pa>
c0103350:	83 c4 10             	add    $0x10,%esp
c0103353:	89 45 e0             	mov    %eax,-0x20(%ebp)
            cprintf("pt_pa = 0x%08x\n", pt_pa);
c0103356:	83 ec 08             	sub    $0x8,%esp
c0103359:	ff 75 e0             	pushl  -0x20(%ebp)
c010335c:	68 f6 66 10 c0       	push   $0xc01066f6
c0103361:	e8 01 cf ff ff       	call   c0100267 <cprintf>
c0103366:	83 c4 10             	add    $0x10,%esp
            cprintf("KADDR(pt_pa) = 0x%08x\n", KADDR( pt_pa ));
c0103369:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010336c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010336f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103372:	c1 e8 0c             	shr    $0xc,%eax
c0103375:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103378:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010337d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103380:	72 17                	jb     c0103399 <get_pte+0x161>
c0103382:	ff 75 dc             	pushl  -0x24(%ebp)
c0103385:	68 80 65 10 c0       	push   $0xc0106580
c010338a:	68 94 01 00 00       	push   $0x194
c010338f:	68 48 66 10 c0       	push   $0xc0106648
c0103394:	e8 34 d0 ff ff       	call   c01003cd <__panic>
c0103399:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010339c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033a1:	83 ec 08             	sub    $0x8,%esp
c01033a4:	50                   	push   %eax
c01033a5:	68 06 67 10 c0       	push   $0xc0106706
c01033aa:	e8 b8 ce ff ff       	call   c0100267 <cprintf>
c01033af:	83 c4 10             	add    $0x10,%esp
            memset( KADDR( pt_pa ), 0, PGSIZE );
c01033b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01033b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033bb:	c1 e8 0c             	shr    $0xc,%eax
c01033be:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033c1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01033c6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01033c9:	72 17                	jb     c01033e2 <get_pte+0x1aa>
c01033cb:	ff 75 d4             	pushl  -0x2c(%ebp)
c01033ce:	68 80 65 10 c0       	push   $0xc0106580
c01033d3:	68 95 01 00 00       	push   $0x195
c01033d8:	68 48 66 10 c0       	push   $0xc0106648
c01033dd:	e8 eb cf ff ff       	call   c01003cd <__panic>
c01033e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033ea:	83 ec 04             	sub    $0x4,%esp
c01033ed:	68 00 10 00 00       	push   $0x1000
c01033f2:	6a 00                	push   $0x0
c01033f4:	50                   	push   %eax
c01033f5:	e8 9c 22 00 00       	call   c0105696 <memset>
c01033fa:	83 c4 10             	add    $0x10,%esp
            pgdir[ pdx ] = pt_pa | ( PTE_P | PTE_W | PTE_U ); 
c01033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103400:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103407:	8b 45 08             	mov    0x8(%ebp),%eax
c010340a:	01 d0                	add    %edx,%eax
c010340c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010340f:	83 ca 07             	or     $0x7,%edx
c0103412:	89 10                	mov    %edx,(%eax)
        }
        return &( ( pte_t * )( KADDR( PDE_ADDR( pgdir[ pdx ] ) ) ) )[ ptx ]; 
c0103414:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010341e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103421:	01 d0                	add    %edx,%eax
c0103423:	8b 00                	mov    (%eax),%eax
c0103425:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010342a:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010342d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103430:	c1 e8 0c             	shr    $0xc,%eax
c0103433:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103436:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010343b:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c010343e:	72 17                	jb     c0103457 <get_pte+0x21f>
c0103440:	ff 75 cc             	pushl  -0x34(%ebp)
c0103443:	68 80 65 10 c0       	push   $0xc0106580
c0103448:	68 98 01 00 00       	push   $0x198
c010344d:	68 48 66 10 c0       	push   $0xc0106648
c0103452:	e8 76 cf ff ff       	call   c01003cd <__panic>
c0103457:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010345a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010345f:	89 c2                	mov    %eax,%edx
c0103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103464:	c1 e0 02             	shl    $0x2,%eax
c0103467:	01 d0                	add    %edx,%eax
    }
}
c0103469:	c9                   	leave  
c010346a:	c3                   	ret    

c010346b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010346b:	55                   	push   %ebp
c010346c:	89 e5                	mov    %esp,%ebp
c010346e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103471:	83 ec 04             	sub    $0x4,%esp
c0103474:	6a 00                	push   $0x0
c0103476:	ff 75 0c             	pushl  0xc(%ebp)
c0103479:	ff 75 08             	pushl  0x8(%ebp)
c010347c:	e8 b7 fd ff ff       	call   c0103238 <get_pte>
c0103481:	83 c4 10             	add    $0x10,%esp
c0103484:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010348b:	74 08                	je     c0103495 <get_page+0x2a>
        *ptep_store = ptep;
c010348d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103490:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103493:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103499:	74 1f                	je     c01034ba <get_page+0x4f>
c010349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010349e:	8b 00                	mov    (%eax),%eax
c01034a0:	83 e0 01             	and    $0x1,%eax
c01034a3:	85 c0                	test   %eax,%eax
c01034a5:	74 13                	je     c01034ba <get_page+0x4f>
        return pte2page(*ptep);
c01034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034aa:	8b 00                	mov    (%eax),%eax
c01034ac:	83 ec 0c             	sub    $0xc,%esp
c01034af:	50                   	push   %eax
c01034b0:	e8 57 f4 ff ff       	call   c010290c <pte2page>
c01034b5:	83 c4 10             	add    $0x10,%esp
c01034b8:	eb 05                	jmp    c01034bf <get_page+0x54>
    }
    return NULL;
c01034ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034bf:	c9                   	leave  
c01034c0:	c3                   	ret    

c01034c1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01034c1:	55                   	push   %ebp
c01034c2:	89 e5                	mov    %esp,%ebp
c01034c4:	83 ec 18             	sub    $0x18,%esp
#endif
    
    uintptr_t pdx, ptx, pt_pa;
    struct Page *rm_page_table; 
    
    pdx = PDX( la );
c01034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034ca:	c1 e8 16             	shr    $0x16,%eax
c01034cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ptx = PTX( la );
c01034d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034d3:	c1 e8 0c             	shr    $0xc,%eax
c01034d6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01034db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if( pgdir[ pdx ] & PTE_P )
c01034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01034e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01034eb:	01 d0                	add    %edx,%eax
c01034ed:	8b 00                	mov    (%eax),%eax
c01034ef:	83 e0 01             	and    $0x1,%eax
c01034f2:	85 c0                	test   %eax,%eax
c01034f4:	74 55                	je     c010354b <page_remove_pte+0x8a>
    {
        rm_page_table = pte2page( *ptep ); 
c01034f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01034f9:	8b 00                	mov    (%eax),%eax
c01034fb:	83 ec 0c             	sub    $0xc,%esp
c01034fe:	50                   	push   %eax
c01034ff:	e8 08 f4 ff ff       	call   c010290c <pte2page>
c0103504:	83 c4 10             	add    $0x10,%esp
c0103507:	89 45 ec             	mov    %eax,-0x14(%ebp)
        page_ref_dec( rm_page_table );
c010350a:	83 ec 0c             	sub    $0xc,%esp
c010350d:	ff 75 ec             	pushl  -0x14(%ebp)
c0103510:	e8 7c f4 ff ff       	call   c0102991 <page_ref_dec>
c0103515:	83 c4 10             	add    $0x10,%esp

        if( rm_page_table->ref == 0 )
c0103518:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010351b:	8b 00                	mov    (%eax),%eax
c010351d:	85 c0                	test   %eax,%eax
c010351f:	75 10                	jne    c0103531 <page_remove_pte+0x70>
            free_page( rm_page_table );
c0103521:	83 ec 08             	sub    $0x8,%esp
c0103524:	6a 01                	push   $0x1
c0103526:	ff 75 ec             	pushl  -0x14(%ebp)
c0103529:	e8 80 f6 ff ff       	call   c0102bae <free_pages>
c010352e:	83 c4 10             	add    $0x10,%esp
        
        *ptep = NULL; 
c0103531:	8b 45 10             	mov    0x10(%ebp),%eax
c0103534:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate( pgdir, la );
c010353a:	83 ec 08             	sub    $0x8,%esp
c010353d:	ff 75 0c             	pushl  0xc(%ebp)
c0103540:	ff 75 08             	pushl  0x8(%ebp)
c0103543:	e8 f8 00 00 00       	call   c0103640 <tlb_invalidate>
c0103548:	83 c4 10             	add    $0x10,%esp
    }
}
c010354b:	90                   	nop
c010354c:	c9                   	leave  
c010354d:	c3                   	ret    

c010354e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010354e:	55                   	push   %ebp
c010354f:	89 e5                	mov    %esp,%ebp
c0103551:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103554:	83 ec 04             	sub    $0x4,%esp
c0103557:	6a 00                	push   $0x0
c0103559:	ff 75 0c             	pushl  0xc(%ebp)
c010355c:	ff 75 08             	pushl  0x8(%ebp)
c010355f:	e8 d4 fc ff ff       	call   c0103238 <get_pte>
c0103564:	83 c4 10             	add    $0x10,%esp
c0103567:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010356a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010356e:	74 14                	je     c0103584 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0103570:	83 ec 04             	sub    $0x4,%esp
c0103573:	ff 75 f4             	pushl  -0xc(%ebp)
c0103576:	ff 75 0c             	pushl  0xc(%ebp)
c0103579:	ff 75 08             	pushl  0x8(%ebp)
c010357c:	e8 40 ff ff ff       	call   c01034c1 <page_remove_pte>
c0103581:	83 c4 10             	add    $0x10,%esp
    }
}
c0103584:	90                   	nop
c0103585:	c9                   	leave  
c0103586:	c3                   	ret    

c0103587 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103587:	55                   	push   %ebp
c0103588:	89 e5                	mov    %esp,%ebp
c010358a:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010358d:	83 ec 04             	sub    $0x4,%esp
c0103590:	6a 01                	push   $0x1
c0103592:	ff 75 10             	pushl  0x10(%ebp)
c0103595:	ff 75 08             	pushl  0x8(%ebp)
c0103598:	e8 9b fc ff ff       	call   c0103238 <get_pte>
c010359d:	83 c4 10             	add    $0x10,%esp
c01035a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01035a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035a7:	75 0a                	jne    c01035b3 <page_insert+0x2c>
        return -E_NO_MEM;
c01035a9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01035ae:	e9 8b 00 00 00       	jmp    c010363e <page_insert+0xb7>
    }
    page_ref_inc(page);
c01035b3:	83 ec 0c             	sub    $0xc,%esp
c01035b6:	ff 75 0c             	pushl  0xc(%ebp)
c01035b9:	e8 bc f3 ff ff       	call   c010297a <page_ref_inc>
c01035be:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c4:	8b 00                	mov    (%eax),%eax
c01035c6:	83 e0 01             	and    $0x1,%eax
c01035c9:	85 c0                	test   %eax,%eax
c01035cb:	74 40                	je     c010360d <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d0:	8b 00                	mov    (%eax),%eax
c01035d2:	83 ec 0c             	sub    $0xc,%esp
c01035d5:	50                   	push   %eax
c01035d6:	e8 31 f3 ff ff       	call   c010290c <pte2page>
c01035db:	83 c4 10             	add    $0x10,%esp
c01035de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01035e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01035e7:	75 10                	jne    c01035f9 <page_insert+0x72>
            page_ref_dec(page);
c01035e9:	83 ec 0c             	sub    $0xc,%esp
c01035ec:	ff 75 0c             	pushl  0xc(%ebp)
c01035ef:	e8 9d f3 ff ff       	call   c0102991 <page_ref_dec>
c01035f4:	83 c4 10             	add    $0x10,%esp
c01035f7:	eb 14                	jmp    c010360d <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01035f9:	83 ec 04             	sub    $0x4,%esp
c01035fc:	ff 75 f4             	pushl  -0xc(%ebp)
c01035ff:	ff 75 10             	pushl  0x10(%ebp)
c0103602:	ff 75 08             	pushl  0x8(%ebp)
c0103605:	e8 b7 fe ff ff       	call   c01034c1 <page_remove_pte>
c010360a:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010360d:	83 ec 0c             	sub    $0xc,%esp
c0103610:	ff 75 0c             	pushl  0xc(%ebp)
c0103613:	e8 55 f2 ff ff       	call   c010286d <page2pa>
c0103618:	83 c4 10             	add    $0x10,%esp
c010361b:	0b 45 14             	or     0x14(%ebp),%eax
c010361e:	83 c8 01             	or     $0x1,%eax
c0103621:	89 c2                	mov    %eax,%edx
c0103623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103626:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103628:	83 ec 08             	sub    $0x8,%esp
c010362b:	ff 75 10             	pushl  0x10(%ebp)
c010362e:	ff 75 08             	pushl  0x8(%ebp)
c0103631:	e8 0a 00 00 00       	call   c0103640 <tlb_invalidate>
c0103636:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103639:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010363e:	c9                   	leave  
c010363f:	c3                   	ret    

c0103640 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103640:	55                   	push   %ebp
c0103641:	89 e5                	mov    %esp,%ebp
c0103643:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103646:	0f 20 d8             	mov    %cr3,%eax
c0103649:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c010364c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010364f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103652:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103655:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010365c:	77 17                	ja     c0103675 <tlb_invalidate+0x35>
c010365e:	ff 75 f0             	pushl  -0x10(%ebp)
c0103661:	68 24 66 10 c0       	push   $0xc0106624
c0103666:	68 05 02 00 00       	push   $0x205
c010366b:	68 48 66 10 c0       	push   $0xc0106648
c0103670:	e8 58 cd ff ff       	call   c01003cd <__panic>
c0103675:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103678:	05 00 00 00 40       	add    $0x40000000,%eax
c010367d:	39 c2                	cmp    %eax,%edx
c010367f:	75 0c                	jne    c010368d <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0103681:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103684:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103687:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010368a:	0f 01 38             	invlpg (%eax)
    }
}
c010368d:	90                   	nop
c010368e:	c9                   	leave  
c010368f:	c3                   	ret    

c0103690 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103690:	55                   	push   %ebp
c0103691:	89 e5                	mov    %esp,%ebp
c0103693:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103696:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010369b:	8b 40 18             	mov    0x18(%eax),%eax
c010369e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01036a0:	83 ec 0c             	sub    $0xc,%esp
c01036a3:	68 20 67 10 c0       	push   $0xc0106720
c01036a8:	e8 ba cb ff ff       	call   c0100267 <cprintf>
c01036ad:	83 c4 10             	add    $0x10,%esp
}
c01036b0:	90                   	nop
c01036b1:	c9                   	leave  
c01036b2:	c3                   	ret    

c01036b3 <check_pgdir>:

static void
check_pgdir(void) {
c01036b3:	55                   	push   %ebp
c01036b4:	89 e5                	mov    %esp,%ebp
c01036b6:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01036b9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01036be:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01036c3:	76 19                	jbe    c01036de <check_pgdir+0x2b>
c01036c5:	68 3f 67 10 c0       	push   $0xc010673f
c01036ca:	68 6d 66 10 c0       	push   $0xc010666d
c01036cf:	68 12 02 00 00       	push   $0x212
c01036d4:	68 48 66 10 c0       	push   $0xc0106648
c01036d9:	e8 ef cc ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01036de:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036e3:	85 c0                	test   %eax,%eax
c01036e5:	74 0e                	je     c01036f5 <check_pgdir+0x42>
c01036e7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036ec:	25 ff 0f 00 00       	and    $0xfff,%eax
c01036f1:	85 c0                	test   %eax,%eax
c01036f3:	74 19                	je     c010370e <check_pgdir+0x5b>
c01036f5:	68 5c 67 10 c0       	push   $0xc010675c
c01036fa:	68 6d 66 10 c0       	push   $0xc010666d
c01036ff:	68 13 02 00 00       	push   $0x213
c0103704:	68 48 66 10 c0       	push   $0xc0106648
c0103709:	e8 bf cc ff ff       	call   c01003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010370e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103713:	83 ec 04             	sub    $0x4,%esp
c0103716:	6a 00                	push   $0x0
c0103718:	6a 00                	push   $0x0
c010371a:	50                   	push   %eax
c010371b:	e8 4b fd ff ff       	call   c010346b <get_page>
c0103720:	83 c4 10             	add    $0x10,%esp
c0103723:	85 c0                	test   %eax,%eax
c0103725:	74 19                	je     c0103740 <check_pgdir+0x8d>
c0103727:	68 94 67 10 c0       	push   $0xc0106794
c010372c:	68 6d 66 10 c0       	push   $0xc010666d
c0103731:	68 14 02 00 00       	push   $0x214
c0103736:	68 48 66 10 c0       	push   $0xc0106648
c010373b:	e8 8d cc ff ff       	call   c01003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103740:	83 ec 0c             	sub    $0xc,%esp
c0103743:	6a 01                	push   $0x1
c0103745:	e8 26 f4 ff ff       	call   c0102b70 <alloc_pages>
c010374a:	83 c4 10             	add    $0x10,%esp
c010374d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103750:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103755:	6a 00                	push   $0x0
c0103757:	6a 00                	push   $0x0
c0103759:	ff 75 f4             	pushl  -0xc(%ebp)
c010375c:	50                   	push   %eax
c010375d:	e8 25 fe ff ff       	call   c0103587 <page_insert>
c0103762:	83 c4 10             	add    $0x10,%esp
c0103765:	85 c0                	test   %eax,%eax
c0103767:	74 19                	je     c0103782 <check_pgdir+0xcf>
c0103769:	68 bc 67 10 c0       	push   $0xc01067bc
c010376e:	68 6d 66 10 c0       	push   $0xc010666d
c0103773:	68 18 02 00 00       	push   $0x218
c0103778:	68 48 66 10 c0       	push   $0xc0106648
c010377d:	e8 4b cc ff ff       	call   c01003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103782:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103787:	83 ec 04             	sub    $0x4,%esp
c010378a:	6a 00                	push   $0x0
c010378c:	6a 00                	push   $0x0
c010378e:	50                   	push   %eax
c010378f:	e8 a4 fa ff ff       	call   c0103238 <get_pte>
c0103794:	83 c4 10             	add    $0x10,%esp
c0103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010379a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010379e:	75 19                	jne    c01037b9 <check_pgdir+0x106>
c01037a0:	68 e8 67 10 c0       	push   $0xc01067e8
c01037a5:	68 6d 66 10 c0       	push   $0xc010666d
c01037aa:	68 1b 02 00 00       	push   $0x21b
c01037af:	68 48 66 10 c0       	push   $0xc0106648
c01037b4:	e8 14 cc ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c01037b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037bc:	8b 00                	mov    (%eax),%eax
c01037be:	83 ec 0c             	sub    $0xc,%esp
c01037c1:	50                   	push   %eax
c01037c2:	e8 45 f1 ff ff       	call   c010290c <pte2page>
c01037c7:	83 c4 10             	add    $0x10,%esp
c01037ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037cd:	74 19                	je     c01037e8 <check_pgdir+0x135>
c01037cf:	68 15 68 10 c0       	push   $0xc0106815
c01037d4:	68 6d 66 10 c0       	push   $0xc010666d
c01037d9:	68 1c 02 00 00       	push   $0x21c
c01037de:	68 48 66 10 c0       	push   $0xc0106648
c01037e3:	e8 e5 cb ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 1);
c01037e8:	83 ec 0c             	sub    $0xc,%esp
c01037eb:	ff 75 f4             	pushl  -0xc(%ebp)
c01037ee:	e8 6f f1 ff ff       	call   c0102962 <page_ref>
c01037f3:	83 c4 10             	add    $0x10,%esp
c01037f6:	83 f8 01             	cmp    $0x1,%eax
c01037f9:	74 19                	je     c0103814 <check_pgdir+0x161>
c01037fb:	68 2b 68 10 c0       	push   $0xc010682b
c0103800:	68 6d 66 10 c0       	push   $0xc010666d
c0103805:	68 1d 02 00 00       	push   $0x21d
c010380a:	68 48 66 10 c0       	push   $0xc0106648
c010380f:	e8 b9 cb ff ff       	call   c01003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103814:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103819:	8b 00                	mov    (%eax),%eax
c010381b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103820:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103823:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103826:	c1 e8 0c             	shr    $0xc,%eax
c0103829:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010382c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103831:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103834:	72 17                	jb     c010384d <check_pgdir+0x19a>
c0103836:	ff 75 ec             	pushl  -0x14(%ebp)
c0103839:	68 80 65 10 c0       	push   $0xc0106580
c010383e:	68 1f 02 00 00       	push   $0x21f
c0103843:	68 48 66 10 c0       	push   $0xc0106648
c0103848:	e8 80 cb ff ff       	call   c01003cd <__panic>
c010384d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103850:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103855:	83 c0 04             	add    $0x4,%eax
c0103858:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010385b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103860:	83 ec 04             	sub    $0x4,%esp
c0103863:	6a 00                	push   $0x0
c0103865:	68 00 10 00 00       	push   $0x1000
c010386a:	50                   	push   %eax
c010386b:	e8 c8 f9 ff ff       	call   c0103238 <get_pte>
c0103870:	83 c4 10             	add    $0x10,%esp
c0103873:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103876:	74 19                	je     c0103891 <check_pgdir+0x1de>
c0103878:	68 40 68 10 c0       	push   $0xc0106840
c010387d:	68 6d 66 10 c0       	push   $0xc010666d
c0103882:	68 20 02 00 00       	push   $0x220
c0103887:	68 48 66 10 c0       	push   $0xc0106648
c010388c:	e8 3c cb ff ff       	call   c01003cd <__panic>

    p2 = alloc_page();
c0103891:	83 ec 0c             	sub    $0xc,%esp
c0103894:	6a 01                	push   $0x1
c0103896:	e8 d5 f2 ff ff       	call   c0102b70 <alloc_pages>
c010389b:	83 c4 10             	add    $0x10,%esp
c010389e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01038a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038a6:	6a 06                	push   $0x6
c01038a8:	68 00 10 00 00       	push   $0x1000
c01038ad:	ff 75 e4             	pushl  -0x1c(%ebp)
c01038b0:	50                   	push   %eax
c01038b1:	e8 d1 fc ff ff       	call   c0103587 <page_insert>
c01038b6:	83 c4 10             	add    $0x10,%esp
c01038b9:	85 c0                	test   %eax,%eax
c01038bb:	74 19                	je     c01038d6 <check_pgdir+0x223>
c01038bd:	68 68 68 10 c0       	push   $0xc0106868
c01038c2:	68 6d 66 10 c0       	push   $0xc010666d
c01038c7:	68 23 02 00 00       	push   $0x223
c01038cc:	68 48 66 10 c0       	push   $0xc0106648
c01038d1:	e8 f7 ca ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01038d6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038db:	83 ec 04             	sub    $0x4,%esp
c01038de:	6a 00                	push   $0x0
c01038e0:	68 00 10 00 00       	push   $0x1000
c01038e5:	50                   	push   %eax
c01038e6:	e8 4d f9 ff ff       	call   c0103238 <get_pte>
c01038eb:	83 c4 10             	add    $0x10,%esp
c01038ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038f5:	75 19                	jne    c0103910 <check_pgdir+0x25d>
c01038f7:	68 a0 68 10 c0       	push   $0xc01068a0
c01038fc:	68 6d 66 10 c0       	push   $0xc010666d
c0103901:	68 24 02 00 00       	push   $0x224
c0103906:	68 48 66 10 c0       	push   $0xc0106648
c010390b:	e8 bd ca ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_U);
c0103910:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103913:	8b 00                	mov    (%eax),%eax
c0103915:	83 e0 04             	and    $0x4,%eax
c0103918:	85 c0                	test   %eax,%eax
c010391a:	75 19                	jne    c0103935 <check_pgdir+0x282>
c010391c:	68 d0 68 10 c0       	push   $0xc01068d0
c0103921:	68 6d 66 10 c0       	push   $0xc010666d
c0103926:	68 25 02 00 00       	push   $0x225
c010392b:	68 48 66 10 c0       	push   $0xc0106648
c0103930:	e8 98 ca ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_W);
c0103935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103938:	8b 00                	mov    (%eax),%eax
c010393a:	83 e0 02             	and    $0x2,%eax
c010393d:	85 c0                	test   %eax,%eax
c010393f:	75 19                	jne    c010395a <check_pgdir+0x2a7>
c0103941:	68 de 68 10 c0       	push   $0xc01068de
c0103946:	68 6d 66 10 c0       	push   $0xc010666d
c010394b:	68 26 02 00 00       	push   $0x226
c0103950:	68 48 66 10 c0       	push   $0xc0106648
c0103955:	e8 73 ca ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010395a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010395f:	8b 00                	mov    (%eax),%eax
c0103961:	83 e0 04             	and    $0x4,%eax
c0103964:	85 c0                	test   %eax,%eax
c0103966:	75 19                	jne    c0103981 <check_pgdir+0x2ce>
c0103968:	68 ec 68 10 c0       	push   $0xc01068ec
c010396d:	68 6d 66 10 c0       	push   $0xc010666d
c0103972:	68 27 02 00 00       	push   $0x227
c0103977:	68 48 66 10 c0       	push   $0xc0106648
c010397c:	e8 4c ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 1);
c0103981:	83 ec 0c             	sub    $0xc,%esp
c0103984:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103987:	e8 d6 ef ff ff       	call   c0102962 <page_ref>
c010398c:	83 c4 10             	add    $0x10,%esp
c010398f:	83 f8 01             	cmp    $0x1,%eax
c0103992:	74 19                	je     c01039ad <check_pgdir+0x2fa>
c0103994:	68 02 69 10 c0       	push   $0xc0106902
c0103999:	68 6d 66 10 c0       	push   $0xc010666d
c010399e:	68 28 02 00 00       	push   $0x228
c01039a3:	68 48 66 10 c0       	push   $0xc0106648
c01039a8:	e8 20 ca ff ff       	call   c01003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01039ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039b2:	6a 00                	push   $0x0
c01039b4:	68 00 10 00 00       	push   $0x1000
c01039b9:	ff 75 f4             	pushl  -0xc(%ebp)
c01039bc:	50                   	push   %eax
c01039bd:	e8 c5 fb ff ff       	call   c0103587 <page_insert>
c01039c2:	83 c4 10             	add    $0x10,%esp
c01039c5:	85 c0                	test   %eax,%eax
c01039c7:	74 19                	je     c01039e2 <check_pgdir+0x32f>
c01039c9:	68 14 69 10 c0       	push   $0xc0106914
c01039ce:	68 6d 66 10 c0       	push   $0xc010666d
c01039d3:	68 2a 02 00 00       	push   $0x22a
c01039d8:	68 48 66 10 c0       	push   $0xc0106648
c01039dd:	e8 eb c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 2);
c01039e2:	83 ec 0c             	sub    $0xc,%esp
c01039e5:	ff 75 f4             	pushl  -0xc(%ebp)
c01039e8:	e8 75 ef ff ff       	call   c0102962 <page_ref>
c01039ed:	83 c4 10             	add    $0x10,%esp
c01039f0:	83 f8 02             	cmp    $0x2,%eax
c01039f3:	74 19                	je     c0103a0e <check_pgdir+0x35b>
c01039f5:	68 40 69 10 c0       	push   $0xc0106940
c01039fa:	68 6d 66 10 c0       	push   $0xc010666d
c01039ff:	68 2b 02 00 00       	push   $0x22b
c0103a04:	68 48 66 10 c0       	push   $0xc0106648
c0103a09:	e8 bf c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103a0e:	83 ec 0c             	sub    $0xc,%esp
c0103a11:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a14:	e8 49 ef ff ff       	call   c0102962 <page_ref>
c0103a19:	83 c4 10             	add    $0x10,%esp
c0103a1c:	85 c0                	test   %eax,%eax
c0103a1e:	74 19                	je     c0103a39 <check_pgdir+0x386>
c0103a20:	68 52 69 10 c0       	push   $0xc0106952
c0103a25:	68 6d 66 10 c0       	push   $0xc010666d
c0103a2a:	68 2c 02 00 00       	push   $0x22c
c0103a2f:	68 48 66 10 c0       	push   $0xc0106648
c0103a34:	e8 94 c9 ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a39:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a3e:	83 ec 04             	sub    $0x4,%esp
c0103a41:	6a 00                	push   $0x0
c0103a43:	68 00 10 00 00       	push   $0x1000
c0103a48:	50                   	push   %eax
c0103a49:	e8 ea f7 ff ff       	call   c0103238 <get_pte>
c0103a4e:	83 c4 10             	add    $0x10,%esp
c0103a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a58:	75 19                	jne    c0103a73 <check_pgdir+0x3c0>
c0103a5a:	68 a0 68 10 c0       	push   $0xc01068a0
c0103a5f:	68 6d 66 10 c0       	push   $0xc010666d
c0103a64:	68 2d 02 00 00       	push   $0x22d
c0103a69:	68 48 66 10 c0       	push   $0xc0106648
c0103a6e:	e8 5a c9 ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c0103a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a76:	8b 00                	mov    (%eax),%eax
c0103a78:	83 ec 0c             	sub    $0xc,%esp
c0103a7b:	50                   	push   %eax
c0103a7c:	e8 8b ee ff ff       	call   c010290c <pte2page>
c0103a81:	83 c4 10             	add    $0x10,%esp
c0103a84:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a87:	74 19                	je     c0103aa2 <check_pgdir+0x3ef>
c0103a89:	68 15 68 10 c0       	push   $0xc0106815
c0103a8e:	68 6d 66 10 c0       	push   $0xc010666d
c0103a93:	68 2e 02 00 00       	push   $0x22e
c0103a98:	68 48 66 10 c0       	push   $0xc0106648
c0103a9d:	e8 2b c9 ff ff       	call   c01003cd <__panic>
    assert((*ptep & PTE_U) == 0);
c0103aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa5:	8b 00                	mov    (%eax),%eax
c0103aa7:	83 e0 04             	and    $0x4,%eax
c0103aaa:	85 c0                	test   %eax,%eax
c0103aac:	74 19                	je     c0103ac7 <check_pgdir+0x414>
c0103aae:	68 64 69 10 c0       	push   $0xc0106964
c0103ab3:	68 6d 66 10 c0       	push   $0xc010666d
c0103ab8:	68 2f 02 00 00       	push   $0x22f
c0103abd:	68 48 66 10 c0       	push   $0xc0106648
c0103ac2:	e8 06 c9 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, 0x0);
c0103ac7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103acc:	83 ec 08             	sub    $0x8,%esp
c0103acf:	6a 00                	push   $0x0
c0103ad1:	50                   	push   %eax
c0103ad2:	e8 77 fa ff ff       	call   c010354e <page_remove>
c0103ad7:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103ada:	83 ec 0c             	sub    $0xc,%esp
c0103add:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ae0:	e8 7d ee ff ff       	call   c0102962 <page_ref>
c0103ae5:	83 c4 10             	add    $0x10,%esp
c0103ae8:	83 f8 01             	cmp    $0x1,%eax
c0103aeb:	74 19                	je     c0103b06 <check_pgdir+0x453>
c0103aed:	68 2b 68 10 c0       	push   $0xc010682b
c0103af2:	68 6d 66 10 c0       	push   $0xc010666d
c0103af7:	68 32 02 00 00       	push   $0x232
c0103afc:	68 48 66 10 c0       	push   $0xc0106648
c0103b01:	e8 c7 c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103b06:	83 ec 0c             	sub    $0xc,%esp
c0103b09:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b0c:	e8 51 ee ff ff       	call   c0102962 <page_ref>
c0103b11:	83 c4 10             	add    $0x10,%esp
c0103b14:	85 c0                	test   %eax,%eax
c0103b16:	74 19                	je     c0103b31 <check_pgdir+0x47e>
c0103b18:	68 52 69 10 c0       	push   $0xc0106952
c0103b1d:	68 6d 66 10 c0       	push   $0xc010666d
c0103b22:	68 33 02 00 00       	push   $0x233
c0103b27:	68 48 66 10 c0       	push   $0xc0106648
c0103b2c:	e8 9c c8 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b31:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b36:	83 ec 08             	sub    $0x8,%esp
c0103b39:	68 00 10 00 00       	push   $0x1000
c0103b3e:	50                   	push   %eax
c0103b3f:	e8 0a fa ff ff       	call   c010354e <page_remove>
c0103b44:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103b47:	83 ec 0c             	sub    $0xc,%esp
c0103b4a:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b4d:	e8 10 ee ff ff       	call   c0102962 <page_ref>
c0103b52:	83 c4 10             	add    $0x10,%esp
c0103b55:	85 c0                	test   %eax,%eax
c0103b57:	74 19                	je     c0103b72 <check_pgdir+0x4bf>
c0103b59:	68 79 69 10 c0       	push   $0xc0106979
c0103b5e:	68 6d 66 10 c0       	push   $0xc010666d
c0103b63:	68 36 02 00 00       	push   $0x236
c0103b68:	68 48 66 10 c0       	push   $0xc0106648
c0103b6d:	e8 5b c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103b72:	83 ec 0c             	sub    $0xc,%esp
c0103b75:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b78:	e8 e5 ed ff ff       	call   c0102962 <page_ref>
c0103b7d:	83 c4 10             	add    $0x10,%esp
c0103b80:	85 c0                	test   %eax,%eax
c0103b82:	74 19                	je     c0103b9d <check_pgdir+0x4ea>
c0103b84:	68 52 69 10 c0       	push   $0xc0106952
c0103b89:	68 6d 66 10 c0       	push   $0xc010666d
c0103b8e:	68 37 02 00 00       	push   $0x237
c0103b93:	68 48 66 10 c0       	push   $0xc0106648
c0103b98:	e8 30 c8 ff ff       	call   c01003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103b9d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ba2:	8b 00                	mov    (%eax),%eax
c0103ba4:	83 ec 0c             	sub    $0xc,%esp
c0103ba7:	50                   	push   %eax
c0103ba8:	e8 99 ed ff ff       	call   c0102946 <pde2page>
c0103bad:	83 c4 10             	add    $0x10,%esp
c0103bb0:	83 ec 0c             	sub    $0xc,%esp
c0103bb3:	50                   	push   %eax
c0103bb4:	e8 a9 ed ff ff       	call   c0102962 <page_ref>
c0103bb9:	83 c4 10             	add    $0x10,%esp
c0103bbc:	83 f8 01             	cmp    $0x1,%eax
c0103bbf:	74 19                	je     c0103bda <check_pgdir+0x527>
c0103bc1:	68 8c 69 10 c0       	push   $0xc010698c
c0103bc6:	68 6d 66 10 c0       	push   $0xc010666d
c0103bcb:	68 39 02 00 00       	push   $0x239
c0103bd0:	68 48 66 10 c0       	push   $0xc0106648
c0103bd5:	e8 f3 c7 ff ff       	call   c01003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103bda:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bdf:	8b 00                	mov    (%eax),%eax
c0103be1:	83 ec 0c             	sub    $0xc,%esp
c0103be4:	50                   	push   %eax
c0103be5:	e8 5c ed ff ff       	call   c0102946 <pde2page>
c0103bea:	83 c4 10             	add    $0x10,%esp
c0103bed:	83 ec 08             	sub    $0x8,%esp
c0103bf0:	6a 01                	push   $0x1
c0103bf2:	50                   	push   %eax
c0103bf3:	e8 b6 ef ff ff       	call   c0102bae <free_pages>
c0103bf8:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103bfb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c06:	83 ec 0c             	sub    $0xc,%esp
c0103c09:	68 b3 69 10 c0       	push   $0xc01069b3
c0103c0e:	e8 54 c6 ff ff       	call   c0100267 <cprintf>
c0103c13:	83 c4 10             	add    $0x10,%esp
}
c0103c16:	90                   	nop
c0103c17:	c9                   	leave  
c0103c18:	c3                   	ret    

c0103c19 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c19:	55                   	push   %ebp
c0103c1a:	89 e5                	mov    %esp,%ebp
c0103c1c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c26:	e9 a3 00 00 00       	jmp    c0103cce <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c34:	c1 e8 0c             	shr    $0xc,%eax
c0103c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c3a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c3f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c42:	72 17                	jb     c0103c5b <check_boot_pgdir+0x42>
c0103c44:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c47:	68 80 65 10 c0       	push   $0xc0106580
c0103c4c:	68 45 02 00 00       	push   $0x245
c0103c51:	68 48 66 10 c0       	push   $0xc0106648
c0103c56:	e8 72 c7 ff ff       	call   c01003cd <__panic>
c0103c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c5e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c63:	89 c2                	mov    %eax,%edx
c0103c65:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c6a:	83 ec 04             	sub    $0x4,%esp
c0103c6d:	6a 00                	push   $0x0
c0103c6f:	52                   	push   %edx
c0103c70:	50                   	push   %eax
c0103c71:	e8 c2 f5 ff ff       	call   c0103238 <get_pte>
c0103c76:	83 c4 10             	add    $0x10,%esp
c0103c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103c7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103c80:	75 19                	jne    c0103c9b <check_boot_pgdir+0x82>
c0103c82:	68 d0 69 10 c0       	push   $0xc01069d0
c0103c87:	68 6d 66 10 c0       	push   $0xc010666d
c0103c8c:	68 45 02 00 00       	push   $0x245
c0103c91:	68 48 66 10 c0       	push   $0xc0106648
c0103c96:	e8 32 c7 ff ff       	call   c01003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c9e:	8b 00                	mov    (%eax),%eax
c0103ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ca5:	89 c2                	mov    %eax,%edx
c0103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103caa:	39 c2                	cmp    %eax,%edx
c0103cac:	74 19                	je     c0103cc7 <check_boot_pgdir+0xae>
c0103cae:	68 0d 6a 10 c0       	push   $0xc0106a0d
c0103cb3:	68 6d 66 10 c0       	push   $0xc010666d
c0103cb8:	68 46 02 00 00       	push   $0x246
c0103cbd:	68 48 66 10 c0       	push   $0xc0106648
c0103cc2:	e8 06 c7 ff ff       	call   c01003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103cc7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103cd1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103cd6:	39 c2                	cmp    %eax,%edx
c0103cd8:	0f 82 4d ff ff ff    	jb     c0103c2b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103cde:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ce3:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103ce8:	8b 00                	mov    (%eax),%eax
c0103cea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cef:	89 c2                	mov    %eax,%edx
c0103cf1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103cf9:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103d00:	77 17                	ja     c0103d19 <check_boot_pgdir+0x100>
c0103d02:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103d05:	68 24 66 10 c0       	push   $0xc0106624
c0103d0a:	68 49 02 00 00       	push   $0x249
c0103d0f:	68 48 66 10 c0       	push   $0xc0106648
c0103d14:	e8 b4 c6 ff ff       	call   c01003cd <__panic>
c0103d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d1c:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d21:	39 c2                	cmp    %eax,%edx
c0103d23:	74 19                	je     c0103d3e <check_boot_pgdir+0x125>
c0103d25:	68 24 6a 10 c0       	push   $0xc0106a24
c0103d2a:	68 6d 66 10 c0       	push   $0xc010666d
c0103d2f:	68 49 02 00 00       	push   $0x249
c0103d34:	68 48 66 10 c0       	push   $0xc0106648
c0103d39:	e8 8f c6 ff ff       	call   c01003cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103d3e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d43:	8b 00                	mov    (%eax),%eax
c0103d45:	85 c0                	test   %eax,%eax
c0103d47:	74 19                	je     c0103d62 <check_boot_pgdir+0x149>
c0103d49:	68 58 6a 10 c0       	push   $0xc0106a58
c0103d4e:	68 6d 66 10 c0       	push   $0xc010666d
c0103d53:	68 4b 02 00 00       	push   $0x24b
c0103d58:	68 48 66 10 c0       	push   $0xc0106648
c0103d5d:	e8 6b c6 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103d62:	83 ec 0c             	sub    $0xc,%esp
c0103d65:	6a 01                	push   $0x1
c0103d67:	e8 04 ee ff ff       	call   c0102b70 <alloc_pages>
c0103d6c:	83 c4 10             	add    $0x10,%esp
c0103d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d72:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d77:	6a 02                	push   $0x2
c0103d79:	68 00 01 00 00       	push   $0x100
c0103d7e:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d81:	50                   	push   %eax
c0103d82:	e8 00 f8 ff ff       	call   c0103587 <page_insert>
c0103d87:	83 c4 10             	add    $0x10,%esp
c0103d8a:	85 c0                	test   %eax,%eax
c0103d8c:	74 19                	je     c0103da7 <check_boot_pgdir+0x18e>
c0103d8e:	68 6c 6a 10 c0       	push   $0xc0106a6c
c0103d93:	68 6d 66 10 c0       	push   $0xc010666d
c0103d98:	68 4f 02 00 00       	push   $0x24f
c0103d9d:	68 48 66 10 c0       	push   $0xc0106648
c0103da2:	e8 26 c6 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 1);
c0103da7:	83 ec 0c             	sub    $0xc,%esp
c0103daa:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dad:	e8 b0 eb ff ff       	call   c0102962 <page_ref>
c0103db2:	83 c4 10             	add    $0x10,%esp
c0103db5:	83 f8 01             	cmp    $0x1,%eax
c0103db8:	74 19                	je     c0103dd3 <check_boot_pgdir+0x1ba>
c0103dba:	68 9a 6a 10 c0       	push   $0xc0106a9a
c0103dbf:	68 6d 66 10 c0       	push   $0xc010666d
c0103dc4:	68 50 02 00 00       	push   $0x250
c0103dc9:	68 48 66 10 c0       	push   $0xc0106648
c0103dce:	e8 fa c5 ff ff       	call   c01003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103dd3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103dd8:	6a 02                	push   $0x2
c0103dda:	68 00 11 00 00       	push   $0x1100
c0103ddf:	ff 75 e0             	pushl  -0x20(%ebp)
c0103de2:	50                   	push   %eax
c0103de3:	e8 9f f7 ff ff       	call   c0103587 <page_insert>
c0103de8:	83 c4 10             	add    $0x10,%esp
c0103deb:	85 c0                	test   %eax,%eax
c0103ded:	74 19                	je     c0103e08 <check_boot_pgdir+0x1ef>
c0103def:	68 ac 6a 10 c0       	push   $0xc0106aac
c0103df4:	68 6d 66 10 c0       	push   $0xc010666d
c0103df9:	68 51 02 00 00       	push   $0x251
c0103dfe:	68 48 66 10 c0       	push   $0xc0106648
c0103e03:	e8 c5 c5 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 2);
c0103e08:	83 ec 0c             	sub    $0xc,%esp
c0103e0b:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e0e:	e8 4f eb ff ff       	call   c0102962 <page_ref>
c0103e13:	83 c4 10             	add    $0x10,%esp
c0103e16:	83 f8 02             	cmp    $0x2,%eax
c0103e19:	74 19                	je     c0103e34 <check_boot_pgdir+0x21b>
c0103e1b:	68 e3 6a 10 c0       	push   $0xc0106ae3
c0103e20:	68 6d 66 10 c0       	push   $0xc010666d
c0103e25:	68 52 02 00 00       	push   $0x252
c0103e2a:	68 48 66 10 c0       	push   $0xc0106648
c0103e2f:	e8 99 c5 ff ff       	call   c01003cd <__panic>

    const char *str = "ucore: Hello world!!";
c0103e34:	c7 45 dc f4 6a 10 c0 	movl   $0xc0106af4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103e3b:	83 ec 08             	sub    $0x8,%esp
c0103e3e:	ff 75 dc             	pushl  -0x24(%ebp)
c0103e41:	68 00 01 00 00       	push   $0x100
c0103e46:	e8 72 15 00 00       	call   c01053bd <strcpy>
c0103e4b:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103e4e:	83 ec 08             	sub    $0x8,%esp
c0103e51:	68 00 11 00 00       	push   $0x1100
c0103e56:	68 00 01 00 00       	push   $0x100
c0103e5b:	e8 d7 15 00 00       	call   c0105437 <strcmp>
c0103e60:	83 c4 10             	add    $0x10,%esp
c0103e63:	85 c0                	test   %eax,%eax
c0103e65:	74 19                	je     c0103e80 <check_boot_pgdir+0x267>
c0103e67:	68 0c 6b 10 c0       	push   $0xc0106b0c
c0103e6c:	68 6d 66 10 c0       	push   $0xc010666d
c0103e71:	68 56 02 00 00       	push   $0x256
c0103e76:	68 48 66 10 c0       	push   $0xc0106648
c0103e7b:	e8 4d c5 ff ff       	call   c01003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e80:	83 ec 0c             	sub    $0xc,%esp
c0103e83:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e86:	e8 3c ea ff ff       	call   c01028c7 <page2kva>
c0103e8b:	83 c4 10             	add    $0x10,%esp
c0103e8e:	05 00 01 00 00       	add    $0x100,%eax
c0103e93:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103e96:	83 ec 0c             	sub    $0xc,%esp
c0103e99:	68 00 01 00 00       	push   $0x100
c0103e9e:	e8 c2 14 00 00       	call   c0105365 <strlen>
c0103ea3:	83 c4 10             	add    $0x10,%esp
c0103ea6:	85 c0                	test   %eax,%eax
c0103ea8:	74 19                	je     c0103ec3 <check_boot_pgdir+0x2aa>
c0103eaa:	68 44 6b 10 c0       	push   $0xc0106b44
c0103eaf:	68 6d 66 10 c0       	push   $0xc010666d
c0103eb4:	68 59 02 00 00       	push   $0x259
c0103eb9:	68 48 66 10 c0       	push   $0xc0106648
c0103ebe:	e8 0a c5 ff ff       	call   c01003cd <__panic>

    free_page(p);
c0103ec3:	83 ec 08             	sub    $0x8,%esp
c0103ec6:	6a 01                	push   $0x1
c0103ec8:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ecb:	e8 de ec ff ff       	call   c0102bae <free_pages>
c0103ed0:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103ed3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ed8:	8b 00                	mov    (%eax),%eax
c0103eda:	83 ec 0c             	sub    $0xc,%esp
c0103edd:	50                   	push   %eax
c0103ede:	e8 63 ea ff ff       	call   c0102946 <pde2page>
c0103ee3:	83 c4 10             	add    $0x10,%esp
c0103ee6:	83 ec 08             	sub    $0x8,%esp
c0103ee9:	6a 01                	push   $0x1
c0103eeb:	50                   	push   %eax
c0103eec:	e8 bd ec ff ff       	call   c0102bae <free_pages>
c0103ef1:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103ef4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103eff:	83 ec 0c             	sub    $0xc,%esp
c0103f02:	68 68 6b 10 c0       	push   $0xc0106b68
c0103f07:	e8 5b c3 ff ff       	call   c0100267 <cprintf>
c0103f0c:	83 c4 10             	add    $0x10,%esp
}
c0103f0f:	90                   	nop
c0103f10:	c9                   	leave  
c0103f11:	c3                   	ret    

c0103f12 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103f12:	55                   	push   %ebp
c0103f13:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f18:	83 e0 04             	and    $0x4,%eax
c0103f1b:	85 c0                	test   %eax,%eax
c0103f1d:	74 07                	je     c0103f26 <perm2str+0x14>
c0103f1f:	b8 75 00 00 00       	mov    $0x75,%eax
c0103f24:	eb 05                	jmp    c0103f2b <perm2str+0x19>
c0103f26:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f2b:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103f30:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f3a:	83 e0 02             	and    $0x2,%eax
c0103f3d:	85 c0                	test   %eax,%eax
c0103f3f:	74 07                	je     c0103f48 <perm2str+0x36>
c0103f41:	b8 77 00 00 00       	mov    $0x77,%eax
c0103f46:	eb 05                	jmp    c0103f4d <perm2str+0x3b>
c0103f48:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f4d:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103f52:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103f59:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103f5e:	5d                   	pop    %ebp
c0103f5f:	c3                   	ret    

c0103f60 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f60:	55                   	push   %ebp
c0103f61:	89 e5                	mov    %esp,%ebp
c0103f63:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f66:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f69:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f6c:	72 0e                	jb     c0103f7c <get_pgtable_items+0x1c>
        return 0;
c0103f6e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f73:	e9 9a 00 00 00       	jmp    c0104012 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f78:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103f7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f82:	73 18                	jae    c0103f9c <get_pgtable_items+0x3c>
c0103f84:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f8e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f91:	01 d0                	add    %edx,%eax
c0103f93:	8b 00                	mov    (%eax),%eax
c0103f95:	83 e0 01             	and    $0x1,%eax
c0103f98:	85 c0                	test   %eax,%eax
c0103f9a:	74 dc                	je     c0103f78 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103f9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fa2:	73 69                	jae    c010400d <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103fa4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103fa8:	74 08                	je     c0103fb2 <get_pgtable_items+0x52>
            *left_store = start;
c0103faa:	8b 45 18             	mov    0x18(%ebp),%eax
c0103fad:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fb0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103fb2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fb5:	8d 50 01             	lea    0x1(%eax),%edx
c0103fb8:	89 55 10             	mov    %edx,0x10(%ebp)
c0103fbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fc2:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fc5:	01 d0                	add    %edx,%eax
c0103fc7:	8b 00                	mov    (%eax),%eax
c0103fc9:	83 e0 07             	and    $0x7,%eax
c0103fcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fcf:	eb 04                	jmp    c0103fd5 <get_pgtable_items+0x75>
            start ++;
c0103fd1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fd5:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fd8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fdb:	73 1d                	jae    c0103ffa <get_pgtable_items+0x9a>
c0103fdd:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fe0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fe7:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fea:	01 d0                	add    %edx,%eax
c0103fec:	8b 00                	mov    (%eax),%eax
c0103fee:	83 e0 07             	and    $0x7,%eax
c0103ff1:	89 c2                	mov    %eax,%edx
c0103ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ff6:	39 c2                	cmp    %eax,%edx
c0103ff8:	74 d7                	je     c0103fd1 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103ffa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103ffe:	74 08                	je     c0104008 <get_pgtable_items+0xa8>
            *right_store = start;
c0104000:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104003:	8b 55 10             	mov    0x10(%ebp),%edx
c0104006:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104008:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010400b:	eb 05                	jmp    c0104012 <get_pgtable_items+0xb2>
    }
    return 0;
c010400d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104012:	c9                   	leave  
c0104013:	c3                   	ret    

c0104014 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104014:	55                   	push   %ebp
c0104015:	89 e5                	mov    %esp,%ebp
c0104017:	57                   	push   %edi
c0104018:	56                   	push   %esi
c0104019:	53                   	push   %ebx
c010401a:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010401d:	83 ec 0c             	sub    $0xc,%esp
c0104020:	68 88 6b 10 c0       	push   $0xc0106b88
c0104025:	e8 3d c2 ff ff       	call   c0100267 <cprintf>
c010402a:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c010402d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104034:	e9 e5 00 00 00       	jmp    c010411e <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010403c:	83 ec 0c             	sub    $0xc,%esp
c010403f:	50                   	push   %eax
c0104040:	e8 cd fe ff ff       	call   c0103f12 <perm2str>
c0104045:	83 c4 10             	add    $0x10,%esp
c0104048:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010404a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010404d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104050:	29 c2                	sub    %eax,%edx
c0104052:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104054:	c1 e0 16             	shl    $0x16,%eax
c0104057:	89 c3                	mov    %eax,%ebx
c0104059:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010405c:	c1 e0 16             	shl    $0x16,%eax
c010405f:	89 c1                	mov    %eax,%ecx
c0104061:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104064:	c1 e0 16             	shl    $0x16,%eax
c0104067:	89 c2                	mov    %eax,%edx
c0104069:	8b 75 dc             	mov    -0x24(%ebp),%esi
c010406c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010406f:	29 c6                	sub    %eax,%esi
c0104071:	89 f0                	mov    %esi,%eax
c0104073:	83 ec 08             	sub    $0x8,%esp
c0104076:	57                   	push   %edi
c0104077:	53                   	push   %ebx
c0104078:	51                   	push   %ecx
c0104079:	52                   	push   %edx
c010407a:	50                   	push   %eax
c010407b:	68 b9 6b 10 c0       	push   $0xc0106bb9
c0104080:	e8 e2 c1 ff ff       	call   c0100267 <cprintf>
c0104085:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104088:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010408b:	c1 e0 0a             	shl    $0xa,%eax
c010408e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104091:	eb 4f                	jmp    c01040e2 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104096:	83 ec 0c             	sub    $0xc,%esp
c0104099:	50                   	push   %eax
c010409a:	e8 73 fe ff ff       	call   c0103f12 <perm2str>
c010409f:	83 c4 10             	add    $0x10,%esp
c01040a2:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01040a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040aa:	29 c2                	sub    %eax,%edx
c01040ac:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01040ae:	c1 e0 0c             	shl    $0xc,%eax
c01040b1:	89 c3                	mov    %eax,%ebx
c01040b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040b6:	c1 e0 0c             	shl    $0xc,%eax
c01040b9:	89 c1                	mov    %eax,%ecx
c01040bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040be:	c1 e0 0c             	shl    $0xc,%eax
c01040c1:	89 c2                	mov    %eax,%edx
c01040c3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c01040c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040c9:	29 c6                	sub    %eax,%esi
c01040cb:	89 f0                	mov    %esi,%eax
c01040cd:	83 ec 08             	sub    $0x8,%esp
c01040d0:	57                   	push   %edi
c01040d1:	53                   	push   %ebx
c01040d2:	51                   	push   %ecx
c01040d3:	52                   	push   %edx
c01040d4:	50                   	push   %eax
c01040d5:	68 d8 6b 10 c0       	push   $0xc0106bd8
c01040da:	e8 88 c1 ff ff       	call   c0100267 <cprintf>
c01040df:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01040e2:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01040e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040ed:	89 d3                	mov    %edx,%ebx
c01040ef:	c1 e3 0a             	shl    $0xa,%ebx
c01040f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040f5:	89 d1                	mov    %edx,%ecx
c01040f7:	c1 e1 0a             	shl    $0xa,%ecx
c01040fa:	83 ec 08             	sub    $0x8,%esp
c01040fd:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104100:	52                   	push   %edx
c0104101:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104104:	52                   	push   %edx
c0104105:	56                   	push   %esi
c0104106:	50                   	push   %eax
c0104107:	53                   	push   %ebx
c0104108:	51                   	push   %ecx
c0104109:	e8 52 fe ff ff       	call   c0103f60 <get_pgtable_items>
c010410e:	83 c4 20             	add    $0x20,%esp
c0104111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104118:	0f 85 75 ff ff ff    	jne    c0104093 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010411e:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104123:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104126:	83 ec 08             	sub    $0x8,%esp
c0104129:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010412c:	52                   	push   %edx
c010412d:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104130:	52                   	push   %edx
c0104131:	51                   	push   %ecx
c0104132:	50                   	push   %eax
c0104133:	68 00 04 00 00       	push   $0x400
c0104138:	6a 00                	push   $0x0
c010413a:	e8 21 fe ff ff       	call   c0103f60 <get_pgtable_items>
c010413f:	83 c4 20             	add    $0x20,%esp
c0104142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104145:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104149:	0f 85 ea fe ff ff    	jne    c0104039 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010414f:	83 ec 0c             	sub    $0xc,%esp
c0104152:	68 fc 6b 10 c0       	push   $0xc0106bfc
c0104157:	e8 0b c1 ff ff       	call   c0100267 <cprintf>
c010415c:	83 c4 10             	add    $0x10,%esp
}
c010415f:	90                   	nop
c0104160:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104163:	5b                   	pop    %ebx
c0104164:	5e                   	pop    %esi
c0104165:	5f                   	pop    %edi
c0104166:	5d                   	pop    %ebp
c0104167:	c3                   	ret    

c0104168 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104168:	55                   	push   %ebp
c0104169:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010416b:	8b 45 08             	mov    0x8(%ebp),%eax
c010416e:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0104174:	29 d0                	sub    %edx,%eax
c0104176:	c1 f8 02             	sar    $0x2,%eax
c0104179:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010417f:	5d                   	pop    %ebp
c0104180:	c3                   	ret    

c0104181 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104181:	55                   	push   %ebp
c0104182:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104184:	ff 75 08             	pushl  0x8(%ebp)
c0104187:	e8 dc ff ff ff       	call   c0104168 <page2ppn>
c010418c:	83 c4 04             	add    $0x4,%esp
c010418f:	c1 e0 0c             	shl    $0xc,%eax
}
c0104192:	c9                   	leave  
c0104193:	c3                   	ret    

c0104194 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104194:	55                   	push   %ebp
c0104195:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104197:	8b 45 08             	mov    0x8(%ebp),%eax
c010419a:	8b 00                	mov    (%eax),%eax
}
c010419c:	5d                   	pop    %ebp
c010419d:	c3                   	ret    

c010419e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010419e:	55                   	push   %ebp
c010419f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01041a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01041a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041a7:	89 10                	mov    %edx,(%eax)
}
c01041a9:	90                   	nop
c01041aa:	5d                   	pop    %ebp
c01041ab:	c3                   	ret    

c01041ac <display_free_list>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)
#define DEBUG 0 

static void display_free_list()
{
c01041ac:	55                   	push   %ebp
c01041ad:	89 e5                	mov    %esp,%ebp
c01041af:	83 ec 18             	sub    $0x18,%esp
    list_entry_t *le = &free_list;
c01041b2:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
        
    cprintf( "\n#################################\n" );
c01041b9:	83 ec 0c             	sub    $0xc,%esp
c01041bc:	68 30 6c 10 c0       	push   $0xc0106c30
c01041c1:	e8 a1 c0 ff ff       	call   c0100267 <cprintf>
c01041c6:	83 c4 10             	add    $0x10,%esp
    while( &free_list != ( le = list_next( le ) ) )
c01041c9:	eb 31                	jmp    c01041fc <display_free_list+0x50>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
c01041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ce:	83 e8 0c             	sub    $0xc,%eax
c01041d1:	83 ec 08             	sub    $0x8,%esp
c01041d4:	50                   	push   %eax
c01041d5:	68 54 6c 10 c0       	push   $0xc0106c54
c01041da:	e8 88 c0 ff ff       	call   c0100267 <cprintf>
c01041df:	83 c4 10             	add    $0x10,%esp
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
c01041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041e5:	83 e8 0c             	sub    $0xc,%eax
c01041e8:	8b 40 08             	mov    0x8(%eax),%eax
c01041eb:	83 ec 08             	sub    $0x8,%esp
c01041ee:	50                   	push   %eax
c01041ef:	68 6a 6c 10 c0       	push   $0xc0106c6a
c01041f4:	e8 6e c0 ff ff       	call   c0100267 <cprintf>
c01041f9:	83 c4 10             	add    $0x10,%esp
c01041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104202:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104205:	8b 40 04             	mov    0x4(%eax),%eax
static void display_free_list()
{
    list_entry_t *le = &free_list;
        
    cprintf( "\n#################################\n" );
    while( &free_list != ( le = list_next( le ) ) )
c0104208:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010420b:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104212:	75 b7                	jne    c01041cb <display_free_list+0x1f>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
    }
    cprintf( "#################################\n\n" );
c0104214:	83 ec 0c             	sub    $0xc,%esp
c0104217:	68 80 6c 10 c0       	push   $0xc0106c80
c010421c:	e8 46 c0 ff ff       	call   c0100267 <cprintf>
c0104221:	83 c4 10             	add    $0x10,%esp
}
c0104224:	90                   	nop
c0104225:	c9                   	leave  
c0104226:	c3                   	ret    

c0104227 <default_init>:

static void default_init( void ) 
{
c0104227:	55                   	push   %ebp
c0104228:	89 e5                	mov    %esp,%ebp
c010422a:	83 ec 10             	sub    $0x10,%esp
c010422d:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104234:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104237:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010423a:	89 50 04             	mov    %edx,0x4(%eax)
c010423d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104240:	8b 50 04             	mov    0x4(%eax),%edx
c0104243:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104246:	89 10                	mov    %edx,(%eax)
    list_init( &free_list );
    nr_free = 0;
c0104248:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c010424f:	00 00 00 
}
c0104252:	90                   	nop
c0104253:	c9                   	leave  
c0104254:	c3                   	ret    

c0104255 <default_init_memmap>:

static void default_init_memmap( struct Page *base, size_t n ) 
{
c0104255:	55                   	push   %ebp
c0104256:	89 e5                	mov    %esp,%ebp
c0104258:	83 ec 30             	sub    $0x30,%esp
    struct Page *p = base;
c010425b:	8b 45 08             	mov    0x8(%ebp),%eax
c010425e:	89 45 fc             	mov    %eax,-0x4(%ebp)

    for( ; p != base + n; p++ ) 
c0104261:	eb 23                	jmp    c0104286 <default_init_memmap+0x31>
        p->flags = p->property = p->ref = 0;
c0104263:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c010426c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010426f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104276:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104279:	8b 50 08             	mov    0x8(%eax),%edx
c010427c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010427f:	89 50 04             	mov    %edx,0x4(%eax)

static void default_init_memmap( struct Page *base, size_t n ) 
{
    struct Page *p = base;

    for( ; p != base + n; p++ ) 
c0104282:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
c0104286:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104289:	89 d0                	mov    %edx,%eax
c010428b:	c1 e0 02             	shl    $0x2,%eax
c010428e:	01 d0                	add    %edx,%eax
c0104290:	c1 e0 02             	shl    $0x2,%eax
c0104293:	89 c2                	mov    %eax,%edx
c0104295:	8b 45 08             	mov    0x8(%ebp),%eax
c0104298:	01 d0                	add    %edx,%eax
c010429a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010429d:	75 c4                	jne    c0104263 <default_init_memmap+0xe>
        p->flags = p->property = p->ref = 0;
    
    SetPageProperty(base); 
c010429f:	8b 45 08             	mov    0x8(%ebp),%eax
c01042a2:	83 c0 04             	add    $0x4,%eax
c01042a5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
c01042ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01042af:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01042b5:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c01042b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01042bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042be:	89 50 08             	mov    %edx,0x8(%eax)
    list_add( &free_list, &( base->page_link ) );
c01042c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01042c4:	83 c0 0c             	add    $0xc,%eax
c01042c7:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
c01042ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042da:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01042dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042e0:	8b 40 04             	mov    0x4(%eax),%eax
c01042e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01042e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01042e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01042ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01042f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01042f8:	89 10                	mov    %edx,(%eax)
c01042fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042fd:	8b 10                	mov    (%eax),%edx
c01042ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104302:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104308:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010430b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010430e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104311:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104314:	89 10                	mov    %edx,(%eax)
    nr_free += n;
c0104316:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010431c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010431f:	01 d0                	add    %edx,%eax
c0104321:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c0104326:	90                   	nop
c0104327:	c9                   	leave  
c0104328:	c3                   	ret    

c0104329 <default_alloc_pages>:

static struct Page *default_alloc_pages( size_t n ) 
{
c0104329:	55                   	push   %ebp
c010432a:	89 e5                	mov    %esp,%ebp
c010432c:	83 ec 50             	sub    $0x50,%esp
    struct Page *page = NULL, *rp = NULL;
c010432f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104336:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010433d:	c7 45 f8 5c 89 11 c0 	movl   $0xc011895c,-0x8(%ebp)
    int i;

    if( n > nr_free ) 
c0104344:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104349:	3b 45 08             	cmp    0x8(%ebp),%eax
c010434c:	0f 83 54 01 00 00    	jae    c01044a6 <default_alloc_pages+0x17d>
        return NULL;
c0104352:	b8 00 00 00 00       	mov    $0x0,%eax
c0104357:	e9 69 01 00 00       	jmp    c01044c5 <default_alloc_pages+0x19c>
    
    while( &free_list != ( le = list_next( le ) ) )  
    {
        struct Page *p = le2page(le, page_link), *pp;
c010435c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010435f:	83 e8 0c             	sub    $0xc,%eax
c0104362:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        if( p->property >= n ) 
c0104365:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104368:	8b 40 08             	mov    0x8(%eax),%eax
c010436b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010436e:	0f 82 32 01 00 00    	jb     c01044a6 <default_alloc_pages+0x17d>
        {
            page = p;
c0104374:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104377:	89 45 fc             	mov    %eax,-0x4(%ebp)
            
            for( i = 0; i < n; i++ )
c010437a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104381:	eb 3e                	jmp    c01043c1 <default_alloc_pages+0x98>
            {
                pp = page + i; 
c0104383:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104386:	89 d0                	mov    %edx,%eax
c0104388:	c1 e0 02             	shl    $0x2,%eax
c010438b:	01 d0                	add    %edx,%eax
c010438d:	c1 e0 02             	shl    $0x2,%eax
c0104390:	89 c2                	mov    %eax,%edx
c0104392:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104395:	01 d0                	add    %edx,%eax
c0104397:	89 45 e8             	mov    %eax,-0x18(%ebp)
                pp->flags = 0;
c010439a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010439d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageReserved(pp);
c01043a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043a7:	83 c0 04             	add    $0x4,%eax
c01043aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c01043b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01043b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043ba:	0f ab 10             	bts    %edx,(%eax)
        
        if( p->property >= n ) 
        {
            page = p;
            
            for( i = 0; i < n; i++ )
c01043bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01043c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043c7:	72 ba                	jb     c0104383 <default_alloc_pages+0x5a>
                pp = page + i; 
                pp->flags = 0;
                SetPageReserved(pp);
            } 
            
            if( page->property > n)
c01043c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043cc:	8b 40 08             	mov    0x8(%eax),%eax
c01043cf:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043d2:	0f 86 8a 00 00 00    	jbe    c0104462 <default_alloc_pages+0x139>
            {
                ( page + n )->property = page->property - n;
c01043d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01043db:	89 d0                	mov    %edx,%eax
c01043dd:	c1 e0 02             	shl    $0x2,%eax
c01043e0:	01 d0                	add    %edx,%eax
c01043e2:	c1 e0 02             	shl    $0x2,%eax
c01043e5:	89 c2                	mov    %eax,%edx
c01043e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043ea:	01 c2                	add    %eax,%edx
c01043ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043ef:	8b 40 08             	mov    0x8(%eax),%eax
c01043f2:	2b 45 08             	sub    0x8(%ebp),%eax
c01043f5:	89 42 08             	mov    %eax,0x8(%edx)
                list_add( &( page->page_link ), &( ( page + n )->page_link ) );
c01043f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01043fb:	89 d0                	mov    %edx,%eax
c01043fd:	c1 e0 02             	shl    $0x2,%eax
c0104400:	01 d0                	add    %edx,%eax
c0104402:	c1 e0 02             	shl    $0x2,%eax
c0104405:	89 c2                	mov    %eax,%edx
c0104407:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010440a:	01 d0                	add    %edx,%eax
c010440c:	83 c0 0c             	add    $0xc,%eax
c010440f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104412:	83 c2 0c             	add    $0xc,%edx
c0104415:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104418:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010441b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104421:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104424:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104427:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010442a:	8b 40 04             	mov    0x4(%eax),%eax
c010442d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104430:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104433:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104436:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104439:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010443c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010443f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104442:	89 10                	mov    %edx,(%eax)
c0104444:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104447:	8b 10                	mov    (%eax),%edx
c0104449:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010444c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010444f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104452:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104455:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104458:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010445b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010445e:	89 10                	mov    %edx,(%eax)
c0104460:	eb 0a                	jmp    c010446c <default_alloc_pages+0x143>
                //rp = page + n;
            }
            else
            {
                page->property = 0;
c0104462:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104465:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                //rp = page;
            }

            list_del( &( page->page_link ) );
c010446c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010446f:	83 c0 0c             	add    $0xc,%eax
c0104472:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104475:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104478:	8b 40 04             	mov    0x4(%eax),%eax
c010447b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010447e:	8b 12                	mov    (%edx),%edx
c0104480:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104483:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104486:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104489:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010448c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010448f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104492:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104495:	89 10                	mov    %edx,(%eax)
            
            nr_free -= n;
c0104497:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010449c:	2b 45 08             	sub    0x8(%ebp),%eax
c010449f:	a3 64 89 11 c0       	mov    %eax,0xc0118964
            break;
c01044a4:	eb 1c                	jmp    c01044c2 <default_alloc_pages+0x199>
c01044a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01044a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01044ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044af:	8b 40 04             	mov    0x4(%eax),%eax
    int i;

    if( n > nr_free ) 
        return NULL;
    
    while( &free_list != ( le = list_next( le ) ) )  
c01044b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01044b5:	81 7d f8 5c 89 11 c0 	cmpl   $0xc011895c,-0x8(%ebp)
c01044bc:	0f 85 9a fe ff ff    	jne    c010435c <default_alloc_pages+0x33>
            nr_free -= n;
            break;
        }
    }
    
    return page;
c01044c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01044c5:	c9                   	leave  
c01044c6:	c3                   	ret    

c01044c7 <default_free_pages>:

static void default_free_pages( struct Page *base, size_t n ) 
{
c01044c7:	55                   	push   %ebp
c01044c8:	89 e5                	mov    %esp,%ebp
c01044ca:	81 ec d0 00 00 00    	sub    $0xd0,%esp
    struct Page *p = base, *page, *front_merge_p;
c01044d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    list_entry_t *le = &free_list; 
c01044d6:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    size_t merge_front = 0, merge_back = 0;
c01044dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01044e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
c01044eb:	eb 1b                	jmp    c0104508 <default_free_pages+0x41>

#if DEBUG
        assert( !PageReserved(p) && !PageProperty(p) );
#endif
        
        p->flags = 0;
c01044ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref( p, 0 );
c01044f7:	6a 00                	push   $0x0
c01044f9:	ff 75 fc             	pushl  -0x4(%ebp)
c01044fc:	e8 9d fc ff ff       	call   c010419e <set_page_ref>
c0104501:	83 c4 08             	add    $0x8,%esp

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
c0104504:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
c0104508:	8b 55 0c             	mov    0xc(%ebp),%edx
c010450b:	89 d0                	mov    %edx,%eax
c010450d:	c1 e0 02             	shl    $0x2,%eax
c0104510:	01 d0                	add    %edx,%eax
c0104512:	c1 e0 02             	shl    $0x2,%eax
c0104515:	89 c2                	mov    %eax,%edx
c0104517:	8b 45 08             	mov    0x8(%ebp),%eax
c010451a:	01 d0                	add    %edx,%eax
c010451c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010451f:	75 cc                	jne    c01044ed <default_free_pages+0x26>
        
        p->flags = 0;
        set_page_ref( p, 0 );
    }
    
    SetPageProperty(base);
c0104521:	8b 45 08             	mov    0x8(%ebp),%eax
c0104524:	83 c0 04             	add    $0x4,%eax
c0104527:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010452e:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104531:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104534:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104537:	0f ab 10             	bts    %edx,(%eax)
    base->property = n; 
c010453a:	8b 45 08             	mov    0x8(%ebp),%eax
c010453d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104540:	89 50 08             	mov    %edx,0x8(%eax)
c0104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104546:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104549:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010454c:	8b 40 04             	mov    0x4(%eax),%eax
    
    if( &free_list == list_next( le ) ) 
c010454f:	3d 5c 89 11 c0       	cmp    $0xc011895c,%eax
c0104554:	0f 85 09 02 00 00    	jne    c0104763 <default_free_pages+0x29c>
    {
        base->flags = 0;
c010455a:	8b 45 08             	mov    0x8(%ebp),%eax
c010455d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(base); 
c0104564:	8b 45 08             	mov    0x8(%ebp),%eax
c0104567:	83 c0 04             	add    $0x4,%eax
c010456a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0104571:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104574:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104577:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010457a:	0f ab 10             	bts    %edx,(%eax)
        list_add( &free_list, &( base->page_link ) );
c010457d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104580:	83 c0 0c             	add    $0xc,%eax
c0104583:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
c010458a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010458d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104590:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104593:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104596:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104599:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010459c:	8b 40 04             	mov    0x4(%eax),%eax
c010459f:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01045a2:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01045a5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01045a8:	89 55 98             	mov    %edx,-0x68(%ebp)
c01045ab:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01045ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01045b1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01045b4:	89 10                	mov    %edx,(%eax)
c01045b6:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01045b9:	8b 10                	mov    (%eax),%edx
c01045bb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01045be:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01045c1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01045c4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01045c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01045ca:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01045cd:	8b 55 98             	mov    -0x68(%ebp),%edx
c01045d0:	89 10                	mov    %edx,(%eax)
c01045d2:	e9 93 03 00 00       	jmp    c010496a <default_free_pages+0x4a3>
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
        {
            page = le2page( le, page_link );
c01045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045da:	83 e8 0c             	sub    $0xc,%eax
c01045dd:	89 45 d0             	mov    %eax,-0x30(%ebp)

            if( base == page + page->property )
c01045e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045e3:	8b 50 08             	mov    0x8(%eax),%edx
c01045e6:	89 d0                	mov    %edx,%eax
c01045e8:	c1 e0 02             	shl    $0x2,%eax
c01045eb:	01 d0                	add    %edx,%eax
c01045ed:	c1 e0 02             	shl    $0x2,%eax
c01045f0:	89 c2                	mov    %eax,%edx
c01045f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045f5:	01 d0                	add    %edx,%eax
c01045f7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01045fa:	75 28                	jne    c0104624 <default_free_pages+0x15d>
            {
                front_merge_p = page;
c01045fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
                base->flags = 0;
c0104602:	8b 45 08             	mov    0x8(%ebp),%eax
c0104605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                page->property += n;
c010460c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010460f:	8b 50 08             	mov    0x8(%eax),%edx
c0104612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104615:	01 c2                	add    %eax,%edx
c0104617:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010461a:	89 50 08             	mov    %edx,0x8(%eax)
                merge_front = 1;
c010461d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }

            if( page == base + base->property )
c0104624:	8b 45 08             	mov    0x8(%ebp),%eax
c0104627:	8b 50 08             	mov    0x8(%eax),%edx
c010462a:	89 d0                	mov    %edx,%eax
c010462c:	c1 e0 02             	shl    $0x2,%eax
c010462f:	01 d0                	add    %edx,%eax
c0104631:	c1 e0 02             	shl    $0x2,%eax
c0104634:	89 c2                	mov    %eax,%edx
c0104636:	8b 45 08             	mov    0x8(%ebp),%eax
c0104639:	01 d0                	add    %edx,%eax
c010463b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010463e:	0f 85 1f 01 00 00    	jne    c0104763 <default_free_pages+0x29c>
            {
                if( 1 == merge_front )
c0104644:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
c0104648:	75 19                	jne    c0104663 <default_free_pages+0x19c>
                    front_merge_p->property += page->property; 
c010464a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010464d:	8b 50 08             	mov    0x8(%eax),%edx
c0104650:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104653:	8b 40 08             	mov    0x8(%eax),%eax
c0104656:	01 c2                	add    %eax,%edx
c0104658:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010465b:	89 50 08             	mov    %edx,0x8(%eax)
c010465e:	e9 a6 00 00 00       	jmp    c0104709 <default_free_pages+0x242>
                else
                {
                    base->flags = 0;
c0104663:	8b 45 08             	mov    0x8(%ebp),%eax
c0104666:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
c010466d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104670:	83 c0 04             	add    $0x4,%eax
c0104673:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c010467a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c0104680:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0104686:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104689:	0f ab 10             	bts    %edx,(%eax)
                    base->property = n + page->property;
c010468c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010468f:	8b 50 08             	mov    0x8(%eax),%edx
c0104692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104695:	01 c2                	add    %eax,%edx
c0104697:	8b 45 08             	mov    0x8(%ebp),%eax
c010469a:	89 50 08             	mov    %edx,0x8(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) );
c010469d:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a0:	8d 50 0c             	lea    0xc(%eax),%edx
c01046a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046a6:	8b 40 0c             	mov    0xc(%eax),%eax
c01046a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046ac:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01046af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046b2:	89 45 88             	mov    %eax,-0x78(%ebp)
c01046b5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01046b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01046bb:	8b 45 88             	mov    -0x78(%ebp),%eax
c01046be:	8b 40 04             	mov    0x4(%eax),%eax
c01046c1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01046c4:	89 55 80             	mov    %edx,-0x80(%ebp)
c01046c7:	8b 55 88             	mov    -0x78(%ebp),%edx
c01046ca:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c01046d0:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01046d6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01046dc:	8b 55 80             	mov    -0x80(%ebp),%edx
c01046df:	89 10                	mov    %edx,(%eax)
c01046e1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01046e7:	8b 10                	mov    (%eax),%edx
c01046e9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01046ef:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01046f2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01046f5:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c01046fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01046fe:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104701:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104707:	89 10                	mov    %edx,(%eax)
                }

                page->flags = page->property = 0;
c0104709:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010470c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104713:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104716:	8b 50 08             	mov    0x8(%eax),%edx
c0104719:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010471c:	89 50 04             	mov    %edx,0x4(%eax)
                list_del( &( page->page_link ) );
c010471f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104722:	83 c0 0c             	add    $0xc,%eax
c0104725:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104728:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010472b:	8b 40 04             	mov    0x4(%eax),%eax
c010472e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104731:	8b 12                	mov    (%edx),%edx
c0104733:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0104739:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010473f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0104745:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c010474b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010474e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0104754:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c010475a:	89 10                	mov    %edx,(%eax)
                merge_back = 1;
c010475c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104766:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104769:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010476c:	8b 40 04             	mov    0x4(%eax),%eax
        SetPageProperty(base); 
        list_add( &free_list, &( base->page_link ) );
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
c010476f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104772:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104779:	0f 85 58 fe ff ff    	jne    c01045d7 <default_free_pages+0x110>
                list_del( &( page->page_link ) );
                merge_back = 1;
            }
        }
        
        if( 1 == merge_front )
c010477f:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
c0104783:	75 0f                	jne    c0104794 <default_free_pages+0x2cd>
            base->property = 0;
c0104785:	8b 45 08             	mov    0x8(%ebp),%eax
c0104788:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010478f:	e9 d6 01 00 00       	jmp    c010496a <default_free_pages+0x4a3>
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
c0104794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104798:	0f 85 cc 01 00 00    	jne    c010496a <default_free_pages+0x4a3>
c010479e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01047a2:	0f 85 c2 01 00 00    	jne    c010496a <default_free_pages+0x4a3>
        {
            size_t found = 0;
c01047a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

            le = &free_list; 
c01047af:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
            while( &free_list != ( le = ( list_next( le ) ) ) )
c01047b6:	e9 d4 00 00 00       	jmp    c010488f <default_free_pages+0x3c8>
            {
                page = le2page( le, page_link );
c01047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047be:	83 e8 0c             	sub    $0xc,%eax
c01047c1:	89 45 d0             	mov    %eax,-0x30(%ebp)

                if( page > base )
c01047c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01047c7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01047ca:	0f 86 bf 00 00 00    	jbe    c010488f <default_free_pages+0x3c8>
                {
                    base->flags = 0;
c01047d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
c01047da:	8b 45 08             	mov    0x8(%ebp),%eax
c01047dd:	83 c0 04             	add    $0x4,%eax
c01047e0:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01047e7:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
c01047ed:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
c01047f3:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01047f6:	0f ab 10             	bts    %edx,(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) ); 
c01047f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047fc:	8d 50 0c             	lea    0xc(%eax),%edx
c01047ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104802:	8b 40 0c             	mov    0xc(%eax),%eax
c0104805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104808:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
c010480e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104811:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0104817:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c010481d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104823:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0104829:	8b 40 04             	mov    0x4(%eax),%eax
c010482c:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
c0104832:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
c0104838:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c010483e:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
c0104844:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010484a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c0104850:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
c0104856:	89 10                	mov    %edx,(%eax)
c0104858:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c010485e:	8b 10                	mov    (%eax),%edx
c0104860:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
c0104866:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104869:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c010486f:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
c0104875:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104878:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c010487e:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
c0104884:	89 10                	mov    %edx,(%eax)
                    found = 1;
c0104886:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
                    break;
c010488d:	eb 1c                	jmp    c01048ab <default_free_pages+0x3e4>
c010488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104892:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104895:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104898:	8b 40 04             	mov    0x4(%eax),%eax
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
        {
            size_t found = 0;

            le = &free_list; 
            while( &free_list != ( le = ( list_next( le ) ) ) )
c010489b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010489e:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c01048a5:	0f 85 10 ff ff ff    	jne    c01047bb <default_free_pages+0x2f4>
                    found = 1;
                    break;
                }
            }

            if( 0 == found )
c01048ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01048af:	0f 85 b5 00 00 00    	jne    c010496a <default_free_pages+0x4a3>
            {
                base->flags = 0;
c01048b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01048b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageProperty(base); 
c01048bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c2:	83 c0 04             	add    $0x4,%eax
c01048c5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01048cc:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
c01048d2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
c01048d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01048db:	0f ab 10             	bts    %edx,(%eax)
                list_add( free_list.prev, &( base->page_link ) ); 
c01048de:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e1:	8d 50 0c             	lea    0xc(%eax),%edx
c01048e4:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01048e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01048ec:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
c01048f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01048f5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
c01048fb:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
c0104901:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104907:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
c010490d:	8b 40 04             	mov    0x4(%eax),%eax
c0104910:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
c0104916:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
c010491c:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
c0104922:	89 95 3c ff ff ff    	mov    %edx,-0xc4(%ebp)
c0104928:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010492e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
c0104934:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
c010493a:	89 10                	mov    %edx,(%eax)
c010493c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
c0104942:	8b 10                	mov    (%eax),%edx
c0104944:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
c010494a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010494d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0104953:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
c0104959:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010495c:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0104962:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
c0104968:	89 10                	mov    %edx,(%eax)
            }
        }
    }

    nr_free += n;
c010496a:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c0104970:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104973:	01 d0                	add    %edx,%eax
c0104975:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c010497a:	90                   	nop
c010497b:	c9                   	leave  
c010497c:	c3                   	ret    

c010497d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010497d:	55                   	push   %ebp
c010497e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104980:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c0104985:	5d                   	pop    %ebp
c0104986:	c3                   	ret    

c0104987 <basic_check>:

static void
basic_check(void) {
c0104987:	55                   	push   %ebp
c0104988:	89 e5                	mov    %esp,%ebp
c010498a:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010498d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104997:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010499a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01049a0:	83 ec 0c             	sub    $0xc,%esp
c01049a3:	6a 01                	push   $0x1
c01049a5:	e8 c6 e1 ff ff       	call   c0102b70 <alloc_pages>
c01049aa:	83 c4 10             	add    $0x10,%esp
c01049ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01049b4:	75 19                	jne    c01049cf <basic_check+0x48>
c01049b6:	68 a4 6c 10 c0       	push   $0xc0106ca4
c01049bb:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01049c0:	68 f5 00 00 00       	push   $0xf5
c01049c5:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01049ca:	e8 fe b9 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01049cf:	83 ec 0c             	sub    $0xc,%esp
c01049d2:	6a 01                	push   $0x1
c01049d4:	e8 97 e1 ff ff       	call   c0102b70 <alloc_pages>
c01049d9:	83 c4 10             	add    $0x10,%esp
c01049dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049e3:	75 19                	jne    c01049fe <basic_check+0x77>
c01049e5:	68 eb 6c 10 c0       	push   $0xc0106ceb
c01049ea:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01049ef:	68 f6 00 00 00       	push   $0xf6
c01049f4:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01049f9:	e8 cf b9 ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01049fe:	83 ec 0c             	sub    $0xc,%esp
c0104a01:	6a 01                	push   $0x1
c0104a03:	e8 68 e1 ff ff       	call   c0102b70 <alloc_pages>
c0104a08:	83 c4 10             	add    $0x10,%esp
c0104a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a12:	75 19                	jne    c0104a2d <basic_check+0xa6>
c0104a14:	68 07 6d 10 c0       	push   $0xc0106d07
c0104a19:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104a1e:	68 f7 00 00 00       	push   $0xf7
c0104a23:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104a28:	e8 a0 b9 ff ff       	call   c01003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a33:	74 10                	je     c0104a45 <basic_check+0xbe>
c0104a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a3b:	74 08                	je     c0104a45 <basic_check+0xbe>
c0104a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a43:	75 19                	jne    c0104a5e <basic_check+0xd7>
c0104a45:	68 24 6d 10 c0       	push   $0xc0106d24
c0104a4a:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104a4f:	68 f9 00 00 00       	push   $0xf9
c0104a54:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104a59:	e8 6f b9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104a5e:	83 ec 0c             	sub    $0xc,%esp
c0104a61:	ff 75 ec             	pushl  -0x14(%ebp)
c0104a64:	e8 2b f7 ff ff       	call   c0104194 <page_ref>
c0104a69:	83 c4 10             	add    $0x10,%esp
c0104a6c:	85 c0                	test   %eax,%eax
c0104a6e:	75 24                	jne    c0104a94 <basic_check+0x10d>
c0104a70:	83 ec 0c             	sub    $0xc,%esp
c0104a73:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a76:	e8 19 f7 ff ff       	call   c0104194 <page_ref>
c0104a7b:	83 c4 10             	add    $0x10,%esp
c0104a7e:	85 c0                	test   %eax,%eax
c0104a80:	75 12                	jne    c0104a94 <basic_check+0x10d>
c0104a82:	83 ec 0c             	sub    $0xc,%esp
c0104a85:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a88:	e8 07 f7 ff ff       	call   c0104194 <page_ref>
c0104a8d:	83 c4 10             	add    $0x10,%esp
c0104a90:	85 c0                	test   %eax,%eax
c0104a92:	74 19                	je     c0104aad <basic_check+0x126>
c0104a94:	68 48 6d 10 c0       	push   $0xc0106d48
c0104a99:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104a9e:	68 fa 00 00 00       	push   $0xfa
c0104aa3:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104aa8:	e8 20 b9 ff ff       	call   c01003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104aad:	83 ec 0c             	sub    $0xc,%esp
c0104ab0:	ff 75 ec             	pushl  -0x14(%ebp)
c0104ab3:	e8 c9 f6 ff ff       	call   c0104181 <page2pa>
c0104ab8:	83 c4 10             	add    $0x10,%esp
c0104abb:	89 c2                	mov    %eax,%edx
c0104abd:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104ac2:	c1 e0 0c             	shl    $0xc,%eax
c0104ac5:	39 c2                	cmp    %eax,%edx
c0104ac7:	72 19                	jb     c0104ae2 <basic_check+0x15b>
c0104ac9:	68 84 6d 10 c0       	push   $0xc0106d84
c0104ace:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104ad3:	68 fc 00 00 00       	push   $0xfc
c0104ad8:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104add:	e8 eb b8 ff ff       	call   c01003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104ae2:	83 ec 0c             	sub    $0xc,%esp
c0104ae5:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ae8:	e8 94 f6 ff ff       	call   c0104181 <page2pa>
c0104aed:	83 c4 10             	add    $0x10,%esp
c0104af0:	89 c2                	mov    %eax,%edx
c0104af2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104af7:	c1 e0 0c             	shl    $0xc,%eax
c0104afa:	39 c2                	cmp    %eax,%edx
c0104afc:	72 19                	jb     c0104b17 <basic_check+0x190>
c0104afe:	68 a1 6d 10 c0       	push   $0xc0106da1
c0104b03:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104b08:	68 fd 00 00 00       	push   $0xfd
c0104b0d:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104b12:	e8 b6 b8 ff ff       	call   c01003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104b17:	83 ec 0c             	sub    $0xc,%esp
c0104b1a:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b1d:	e8 5f f6 ff ff       	call   c0104181 <page2pa>
c0104b22:	83 c4 10             	add    $0x10,%esp
c0104b25:	89 c2                	mov    %eax,%edx
c0104b27:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104b2c:	c1 e0 0c             	shl    $0xc,%eax
c0104b2f:	39 c2                	cmp    %eax,%edx
c0104b31:	72 19                	jb     c0104b4c <basic_check+0x1c5>
c0104b33:	68 be 6d 10 c0       	push   $0xc0106dbe
c0104b38:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104b3d:	68 fe 00 00 00       	push   $0xfe
c0104b42:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104b47:	e8 81 b8 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104b4c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104b51:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104b57:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b5a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104b5d:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b6a:	89 50 04             	mov    %edx,0x4(%eax)
c0104b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b70:	8b 50 04             	mov    0x4(%eax),%edx
c0104b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b76:	89 10                	mov    %edx,(%eax)
c0104b78:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b82:	8b 40 04             	mov    0x4(%eax),%eax
c0104b85:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104b88:	0f 94 c0             	sete   %al
c0104b8b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104b8e:	85 c0                	test   %eax,%eax
c0104b90:	75 19                	jne    c0104bab <basic_check+0x224>
c0104b92:	68 db 6d 10 c0       	push   $0xc0106ddb
c0104b97:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104b9c:	68 02 01 00 00       	push   $0x102
c0104ba1:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104ba6:	e8 22 b8 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104bab:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104bb3:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104bba:	00 00 00 
    assert(alloc_page() == NULL);
c0104bbd:	83 ec 0c             	sub    $0xc,%esp
c0104bc0:	6a 01                	push   $0x1
c0104bc2:	e8 a9 df ff ff       	call   c0102b70 <alloc_pages>
c0104bc7:	83 c4 10             	add    $0x10,%esp
c0104bca:	85 c0                	test   %eax,%eax
c0104bcc:	74 19                	je     c0104be7 <basic_check+0x260>
c0104bce:	68 f2 6d 10 c0       	push   $0xc0106df2
c0104bd3:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104bd8:	68 06 01 00 00       	push   $0x106
c0104bdd:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104be2:	e8 e6 b7 ff ff       	call   c01003cd <__panic>
    
    free_page(p0);
c0104be7:	83 ec 08             	sub    $0x8,%esp
c0104bea:	6a 01                	push   $0x1
c0104bec:	ff 75 ec             	pushl  -0x14(%ebp)
c0104bef:	e8 ba df ff ff       	call   c0102bae <free_pages>
c0104bf4:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104bf7:	83 ec 08             	sub    $0x8,%esp
c0104bfa:	6a 01                	push   $0x1
c0104bfc:	ff 75 f0             	pushl  -0x10(%ebp)
c0104bff:	e8 aa df ff ff       	call   c0102bae <free_pages>
c0104c04:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104c07:	83 ec 08             	sub    $0x8,%esp
c0104c0a:	6a 01                	push   $0x1
c0104c0c:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c0f:	e8 9a df ff ff       	call   c0102bae <free_pages>
c0104c14:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104c17:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104c1c:	83 f8 03             	cmp    $0x3,%eax
c0104c1f:	74 19                	je     c0104c3a <basic_check+0x2b3>
c0104c21:	68 07 6e 10 c0       	push   $0xc0106e07
c0104c26:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104c2b:	68 0b 01 00 00       	push   $0x10b
c0104c30:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104c35:	e8 93 b7 ff ff       	call   c01003cd <__panic>
    
    assert((p0 = alloc_page()) != NULL);
c0104c3a:	83 ec 0c             	sub    $0xc,%esp
c0104c3d:	6a 01                	push   $0x1
c0104c3f:	e8 2c df ff ff       	call   c0102b70 <alloc_pages>
c0104c44:	83 c4 10             	add    $0x10,%esp
c0104c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104c4e:	75 19                	jne    c0104c69 <basic_check+0x2e2>
c0104c50:	68 a4 6c 10 c0       	push   $0xc0106ca4
c0104c55:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104c5a:	68 0d 01 00 00       	push   $0x10d
c0104c5f:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104c64:	e8 64 b7 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104c69:	83 ec 0c             	sub    $0xc,%esp
c0104c6c:	6a 01                	push   $0x1
c0104c6e:	e8 fd de ff ff       	call   c0102b70 <alloc_pages>
c0104c73:	83 c4 10             	add    $0x10,%esp
c0104c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c7d:	75 19                	jne    c0104c98 <basic_check+0x311>
c0104c7f:	68 eb 6c 10 c0       	push   $0xc0106ceb
c0104c84:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104c89:	68 0e 01 00 00       	push   $0x10e
c0104c8e:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104c93:	e8 35 b7 ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104c98:	83 ec 0c             	sub    $0xc,%esp
c0104c9b:	6a 01                	push   $0x1
c0104c9d:	e8 ce de ff ff       	call   c0102b70 <alloc_pages>
c0104ca2:	83 c4 10             	add    $0x10,%esp
c0104ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cac:	75 19                	jne    c0104cc7 <basic_check+0x340>
c0104cae:	68 07 6d 10 c0       	push   $0xc0106d07
c0104cb3:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104cb8:	68 0f 01 00 00       	push   $0x10f
c0104cbd:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104cc2:	e8 06 b7 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104cc7:	83 ec 0c             	sub    $0xc,%esp
c0104cca:	6a 01                	push   $0x1
c0104ccc:	e8 9f de ff ff       	call   c0102b70 <alloc_pages>
c0104cd1:	83 c4 10             	add    $0x10,%esp
c0104cd4:	85 c0                	test   %eax,%eax
c0104cd6:	74 19                	je     c0104cf1 <basic_check+0x36a>
c0104cd8:	68 f2 6d 10 c0       	push   $0xc0106df2
c0104cdd:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104ce2:	68 10 01 00 00       	push   $0x110
c0104ce7:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104cec:	e8 dc b6 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104cf1:	83 ec 08             	sub    $0x8,%esp
c0104cf4:	6a 01                	push   $0x1
c0104cf6:	ff 75 ec             	pushl  -0x14(%ebp)
c0104cf9:	e8 b0 de ff ff       	call   c0102bae <free_pages>
c0104cfe:	83 c4 10             	add    $0x10,%esp
c0104d01:	c7 45 e8 5c 89 11 c0 	movl   $0xc011895c,-0x18(%ebp)
c0104d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d0b:	8b 40 04             	mov    0x4(%eax),%eax
c0104d0e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104d11:	0f 94 c0             	sete   %al
c0104d14:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104d17:	85 c0                	test   %eax,%eax
c0104d19:	74 19                	je     c0104d34 <basic_check+0x3ad>
c0104d1b:	68 14 6e 10 c0       	push   $0xc0106e14
c0104d20:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104d25:	68 12 01 00 00       	push   $0x112
c0104d2a:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104d2f:	e8 99 b6 ff ff       	call   c01003cd <__panic>
    
    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104d34:	83 ec 0c             	sub    $0xc,%esp
c0104d37:	6a 01                	push   $0x1
c0104d39:	e8 32 de ff ff       	call   c0102b70 <alloc_pages>
c0104d3e:	83 c4 10             	add    $0x10,%esp
c0104d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104d4a:	74 19                	je     c0104d65 <basic_check+0x3de>
c0104d4c:	68 2c 6e 10 c0       	push   $0xc0106e2c
c0104d51:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104d56:	68 15 01 00 00       	push   $0x115
c0104d5b:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104d60:	e8 68 b6 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104d65:	83 ec 0c             	sub    $0xc,%esp
c0104d68:	6a 01                	push   $0x1
c0104d6a:	e8 01 de ff ff       	call   c0102b70 <alloc_pages>
c0104d6f:	83 c4 10             	add    $0x10,%esp
c0104d72:	85 c0                	test   %eax,%eax
c0104d74:	74 19                	je     c0104d8f <basic_check+0x408>
c0104d76:	68 f2 6d 10 c0       	push   $0xc0106df2
c0104d7b:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104d80:	68 16 01 00 00       	push   $0x116
c0104d85:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104d8a:	e8 3e b6 ff ff       	call   c01003cd <__panic>
    assert(nr_free == 0);
c0104d8f:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104d94:	85 c0                	test   %eax,%eax
c0104d96:	74 19                	je     c0104db1 <basic_check+0x42a>
c0104d98:	68 45 6e 10 c0       	push   $0xc0106e45
c0104d9d:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104da2:	68 17 01 00 00       	push   $0x117
c0104da7:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104dac:	e8 1c b6 ff ff       	call   c01003cd <__panic>
    free_list = free_list_store;
c0104db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104db4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104db7:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104dbc:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c0104dc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104dc5:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    free_page(p);
c0104dca:	83 ec 08             	sub    $0x8,%esp
c0104dcd:	6a 01                	push   $0x1
c0104dcf:	ff 75 dc             	pushl  -0x24(%ebp)
c0104dd2:	e8 d7 dd ff ff       	call   c0102bae <free_pages>
c0104dd7:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104dda:	83 ec 08             	sub    $0x8,%esp
c0104ddd:	6a 01                	push   $0x1
c0104ddf:	ff 75 f0             	pushl  -0x10(%ebp)
c0104de2:	e8 c7 dd ff ff       	call   c0102bae <free_pages>
c0104de7:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104dea:	83 ec 08             	sub    $0x8,%esp
c0104ded:	6a 01                	push   $0x1
c0104def:	ff 75 f4             	pushl  -0xc(%ebp)
c0104df2:	e8 b7 dd ff ff       	call   c0102bae <free_pages>
c0104df7:	83 c4 10             	add    $0x10,%esp
}
c0104dfa:	90                   	nop
c0104dfb:	c9                   	leave  
c0104dfc:	c3                   	ret    

c0104dfd <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104dfd:	55                   	push   %ebp
c0104dfe:	89 e5                	mov    %esp,%ebp
c0104e00:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104e06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104e14:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104e1b:	eb 60                	jmp    c0104e7d <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e20:	83 e8 0c             	sub    $0xc,%eax
c0104e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e29:	83 c0 04             	add    $0x4,%eax
c0104e2c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104e33:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e36:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104e39:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104e3c:	0f a3 10             	bt     %edx,(%eax)
c0104e3f:	19 c0                	sbb    %eax,%eax
c0104e41:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104e44:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104e48:	0f 95 c0             	setne  %al
c0104e4b:	0f b6 c0             	movzbl %al,%eax
c0104e4e:	85 c0                	test   %eax,%eax
c0104e50:	75 19                	jne    c0104e6b <default_check+0x6e>
c0104e52:	68 52 6e 10 c0       	push   $0xc0106e52
c0104e57:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104e5c:	68 27 01 00 00       	push   $0x127
c0104e61:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104e66:	e8 62 b5 ff ff       	call   c01003cd <__panic>
        count++, total += p->property;
c0104e6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e72:	8b 50 08             	mov    0x8(%eax),%edx
c0104e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e78:	01 d0                	add    %edx,%eax
c0104e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e86:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104e89:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e8c:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104e93:	75 88                	jne    c0104e1d <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104e95:	e8 49 dd ff ff       	call   c0102be3 <nr_free_pages>
c0104e9a:	89 c2                	mov    %eax,%edx
c0104e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e9f:	39 c2                	cmp    %eax,%edx
c0104ea1:	74 19                	je     c0104ebc <default_check+0xbf>
c0104ea3:	68 62 6e 10 c0       	push   $0xc0106e62
c0104ea8:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104ead:	68 2a 01 00 00       	push   $0x12a
c0104eb2:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104eb7:	e8 11 b5 ff ff       	call   c01003cd <__panic>

    basic_check();
c0104ebc:	e8 c6 fa ff ff       	call   c0104987 <basic_check>
    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104ec1:	83 ec 0c             	sub    $0xc,%esp
c0104ec4:	6a 05                	push   $0x5
c0104ec6:	e8 a5 dc ff ff       	call   c0102b70 <alloc_pages>
c0104ecb:	83 c4 10             	add    $0x10,%esp
c0104ece:	89 45 dc             	mov    %eax,-0x24(%ebp)
    
    assert(p0 != NULL);
c0104ed1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104ed5:	75 19                	jne    c0104ef0 <default_check+0xf3>
c0104ed7:	68 7b 6e 10 c0       	push   $0xc0106e7b
c0104edc:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104ee1:	68 2f 01 00 00       	push   $0x12f
c0104ee6:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104eeb:	e8 dd b4 ff ff       	call   c01003cd <__panic>
    assert(!PageProperty(p0));
c0104ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ef3:	83 c0 04             	add    $0x4,%eax
c0104ef6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104efd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f00:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104f03:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104f06:	0f a3 10             	bt     %edx,(%eax)
c0104f09:	19 c0                	sbb    %eax,%eax
c0104f0b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104f0e:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104f12:	0f 95 c0             	setne  %al
c0104f15:	0f b6 c0             	movzbl %al,%eax
c0104f18:	85 c0                	test   %eax,%eax
c0104f1a:	74 19                	je     c0104f35 <default_check+0x138>
c0104f1c:	68 86 6e 10 c0       	push   $0xc0106e86
c0104f21:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104f26:	68 30 01 00 00       	push   $0x130
c0104f2b:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104f30:	e8 98 b4 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104f35:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104f3a:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104f40:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104f43:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104f46:	c7 45 d0 5c 89 11 c0 	movl   $0xc011895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f50:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104f53:	89 50 04             	mov    %edx,0x4(%eax)
c0104f56:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f59:	8b 50 04             	mov    0x4(%eax),%edx
c0104f5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f5f:	89 10                	mov    %edx,(%eax)
c0104f61:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104f6b:	8b 40 04             	mov    0x4(%eax),%eax
c0104f6e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104f71:	0f 94 c0             	sete   %al
c0104f74:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104f77:	85 c0                	test   %eax,%eax
c0104f79:	75 19                	jne    c0104f94 <default_check+0x197>
c0104f7b:	68 db 6d 10 c0       	push   $0xc0106ddb
c0104f80:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104f85:	68 34 01 00 00       	push   $0x134
c0104f8a:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104f8f:	e8 39 b4 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104f94:	83 ec 0c             	sub    $0xc,%esp
c0104f97:	6a 01                	push   $0x1
c0104f99:	e8 d2 db ff ff       	call   c0102b70 <alloc_pages>
c0104f9e:	83 c4 10             	add    $0x10,%esp
c0104fa1:	85 c0                	test   %eax,%eax
c0104fa3:	74 19                	je     c0104fbe <default_check+0x1c1>
c0104fa5:	68 f2 6d 10 c0       	push   $0xc0106df2
c0104faa:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104faf:	68 35 01 00 00       	push   $0x135
c0104fb4:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0104fb9:	e8 0f b4 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104fbe:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104fc3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104fc6:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104fcd:	00 00 00 

    free_pages(p0 + 2, 3);
c0104fd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fd3:	83 c0 28             	add    $0x28,%eax
c0104fd6:	83 ec 08             	sub    $0x8,%esp
c0104fd9:	6a 03                	push   $0x3
c0104fdb:	50                   	push   %eax
c0104fdc:	e8 cd db ff ff       	call   c0102bae <free_pages>
c0104fe1:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104fe4:	83 ec 0c             	sub    $0xc,%esp
c0104fe7:	6a 04                	push   $0x4
c0104fe9:	e8 82 db ff ff       	call   c0102b70 <alloc_pages>
c0104fee:	83 c4 10             	add    $0x10,%esp
c0104ff1:	85 c0                	test   %eax,%eax
c0104ff3:	74 19                	je     c010500e <default_check+0x211>
c0104ff5:	68 98 6e 10 c0       	push   $0xc0106e98
c0104ffa:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0104fff:	68 3b 01 00 00       	push   $0x13b
c0105004:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0105009:	e8 bf b3 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010500e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105011:	83 c0 28             	add    $0x28,%eax
c0105014:	83 c0 04             	add    $0x4,%eax
c0105017:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010501e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105021:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105027:	0f a3 10             	bt     %edx,(%eax)
c010502a:	19 c0                	sbb    %eax,%eax
c010502c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010502f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105033:	0f 95 c0             	setne  %al
c0105036:	0f b6 c0             	movzbl %al,%eax
c0105039:	85 c0                	test   %eax,%eax
c010503b:	74 0e                	je     c010504b <default_check+0x24e>
c010503d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105040:	83 c0 28             	add    $0x28,%eax
c0105043:	8b 40 08             	mov    0x8(%eax),%eax
c0105046:	83 f8 03             	cmp    $0x3,%eax
c0105049:	74 19                	je     c0105064 <default_check+0x267>
c010504b:	68 b0 6e 10 c0       	push   $0xc0106eb0
c0105050:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105055:	68 3c 01 00 00       	push   $0x13c
c010505a:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010505f:	e8 69 b3 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105064:	83 ec 0c             	sub    $0xc,%esp
c0105067:	6a 03                	push   $0x3
c0105069:	e8 02 db ff ff       	call   c0102b70 <alloc_pages>
c010506e:	83 c4 10             	add    $0x10,%esp
c0105071:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0105074:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0105078:	75 19                	jne    c0105093 <default_check+0x296>
c010507a:	68 dc 6e 10 c0       	push   $0xc0106edc
c010507f:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105084:	68 3d 01 00 00       	push   $0x13d
c0105089:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010508e:	e8 3a b3 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0105093:	83 ec 0c             	sub    $0xc,%esp
c0105096:	6a 01                	push   $0x1
c0105098:	e8 d3 da ff ff       	call   c0102b70 <alloc_pages>
c010509d:	83 c4 10             	add    $0x10,%esp
c01050a0:	85 c0                	test   %eax,%eax
c01050a2:	74 19                	je     c01050bd <default_check+0x2c0>
c01050a4:	68 f2 6d 10 c0       	push   $0xc0106df2
c01050a9:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01050ae:	68 3e 01 00 00       	push   $0x13e
c01050b3:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01050b8:	e8 10 b3 ff ff       	call   c01003cd <__panic>
    assert(p0 + 2 == p1);
c01050bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050c0:	83 c0 28             	add    $0x28,%eax
c01050c3:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c01050c6:	74 19                	je     c01050e1 <default_check+0x2e4>
c01050c8:	68 fa 6e 10 c0       	push   $0xc0106efa
c01050cd:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01050d2:	68 3f 01 00 00       	push   $0x13f
c01050d7:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01050dc:	e8 ec b2 ff ff       	call   c01003cd <__panic>

    p2 = p0 + 1;
c01050e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050e4:	83 c0 14             	add    $0x14,%eax
c01050e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c01050ea:	83 ec 08             	sub    $0x8,%esp
c01050ed:	6a 01                	push   $0x1
c01050ef:	ff 75 dc             	pushl  -0x24(%ebp)
c01050f2:	e8 b7 da ff ff       	call   c0102bae <free_pages>
c01050f7:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c01050fa:	83 ec 08             	sub    $0x8,%esp
c01050fd:	6a 03                	push   $0x3
c01050ff:	ff 75 c4             	pushl  -0x3c(%ebp)
c0105102:	e8 a7 da ff ff       	call   c0102bae <free_pages>
c0105107:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c010510a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010510d:	83 c0 04             	add    $0x4,%eax
c0105110:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0105117:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010511a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010511d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105120:	0f a3 10             	bt     %edx,(%eax)
c0105123:	19 c0                	sbb    %eax,%eax
c0105125:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0105128:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c010512c:	0f 95 c0             	setne  %al
c010512f:	0f b6 c0             	movzbl %al,%eax
c0105132:	85 c0                	test   %eax,%eax
c0105134:	74 0b                	je     c0105141 <default_check+0x344>
c0105136:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105139:	8b 40 08             	mov    0x8(%eax),%eax
c010513c:	83 f8 01             	cmp    $0x1,%eax
c010513f:	74 19                	je     c010515a <default_check+0x35d>
c0105141:	68 08 6f 10 c0       	push   $0xc0106f08
c0105146:	68 c0 6c 10 c0       	push   $0xc0106cc0
c010514b:	68 44 01 00 00       	push   $0x144
c0105150:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0105155:	e8 73 b2 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010515a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010515d:	83 c0 04             	add    $0x4,%eax
c0105160:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0105167:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010516a:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010516d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105170:	0f a3 10             	bt     %edx,(%eax)
c0105173:	19 c0                	sbb    %eax,%eax
c0105175:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0105178:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c010517c:	0f 95 c0             	setne  %al
c010517f:	0f b6 c0             	movzbl %al,%eax
c0105182:	85 c0                	test   %eax,%eax
c0105184:	74 0b                	je     c0105191 <default_check+0x394>
c0105186:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105189:	8b 40 08             	mov    0x8(%eax),%eax
c010518c:	83 f8 03             	cmp    $0x3,%eax
c010518f:	74 19                	je     c01051aa <default_check+0x3ad>
c0105191:	68 30 6f 10 c0       	push   $0xc0106f30
c0105196:	68 c0 6c 10 c0       	push   $0xc0106cc0
c010519b:	68 45 01 00 00       	push   $0x145
c01051a0:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01051a5:	e8 23 b2 ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01051aa:	83 ec 0c             	sub    $0xc,%esp
c01051ad:	6a 01                	push   $0x1
c01051af:	e8 bc d9 ff ff       	call   c0102b70 <alloc_pages>
c01051b4:	83 c4 10             	add    $0x10,%esp
c01051b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01051ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01051bd:	83 e8 14             	sub    $0x14,%eax
c01051c0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01051c3:	74 19                	je     c01051de <default_check+0x3e1>
c01051c5:	68 56 6f 10 c0       	push   $0xc0106f56
c01051ca:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01051cf:	68 47 01 00 00       	push   $0x147
c01051d4:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01051d9:	e8 ef b1 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c01051de:	83 ec 08             	sub    $0x8,%esp
c01051e1:	6a 01                	push   $0x1
c01051e3:	ff 75 dc             	pushl  -0x24(%ebp)
c01051e6:	e8 c3 d9 ff ff       	call   c0102bae <free_pages>
c01051eb:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01051ee:	83 ec 0c             	sub    $0xc,%esp
c01051f1:	6a 02                	push   $0x2
c01051f3:	e8 78 d9 ff ff       	call   c0102b70 <alloc_pages>
c01051f8:	83 c4 10             	add    $0x10,%esp
c01051fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01051fe:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105201:	83 c0 14             	add    $0x14,%eax
c0105204:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105207:	74 19                	je     c0105222 <default_check+0x425>
c0105209:	68 74 6f 10 c0       	push   $0xc0106f74
c010520e:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105213:	68 49 01 00 00       	push   $0x149
c0105218:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010521d:	e8 ab b1 ff ff       	call   c01003cd <__panic>

    free_pages(p0, 2);
c0105222:	83 ec 08             	sub    $0x8,%esp
c0105225:	6a 02                	push   $0x2
c0105227:	ff 75 dc             	pushl  -0x24(%ebp)
c010522a:	e8 7f d9 ff ff       	call   c0102bae <free_pages>
c010522f:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105232:	83 ec 08             	sub    $0x8,%esp
c0105235:	6a 01                	push   $0x1
c0105237:	ff 75 c0             	pushl  -0x40(%ebp)
c010523a:	e8 6f d9 ff ff       	call   c0102bae <free_pages>
c010523f:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105242:	83 ec 0c             	sub    $0xc,%esp
c0105245:	6a 05                	push   $0x5
c0105247:	e8 24 d9 ff ff       	call   c0102b70 <alloc_pages>
c010524c:	83 c4 10             	add    $0x10,%esp
c010524f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105252:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105256:	75 19                	jne    c0105271 <default_check+0x474>
c0105258:	68 94 6f 10 c0       	push   $0xc0106f94
c010525d:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105262:	68 4e 01 00 00       	push   $0x14e
c0105267:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010526c:	e8 5c b1 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0105271:	83 ec 0c             	sub    $0xc,%esp
c0105274:	6a 01                	push   $0x1
c0105276:	e8 f5 d8 ff ff       	call   c0102b70 <alloc_pages>
c010527b:	83 c4 10             	add    $0x10,%esp
c010527e:	85 c0                	test   %eax,%eax
c0105280:	74 19                	je     c010529b <default_check+0x49e>
c0105282:	68 f2 6d 10 c0       	push   $0xc0106df2
c0105287:	68 c0 6c 10 c0       	push   $0xc0106cc0
c010528c:	68 4f 01 00 00       	push   $0x14f
c0105291:	68 d5 6c 10 c0       	push   $0xc0106cd5
c0105296:	e8 32 b1 ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c010529b:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01052a0:	85 c0                	test   %eax,%eax
c01052a2:	74 19                	je     c01052bd <default_check+0x4c0>
c01052a4:	68 45 6e 10 c0       	push   $0xc0106e45
c01052a9:	68 c0 6c 10 c0       	push   $0xc0106cc0
c01052ae:	68 51 01 00 00       	push   $0x151
c01052b3:	68 d5 6c 10 c0       	push   $0xc0106cd5
c01052b8:	e8 10 b1 ff ff       	call   c01003cd <__panic>
    nr_free = nr_free_store;
c01052bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01052c0:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c01052c5:	8b 45 80             	mov    -0x80(%ebp),%eax
c01052c8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01052cb:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c01052d0:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c01052d6:	83 ec 08             	sub    $0x8,%esp
c01052d9:	6a 05                	push   $0x5
c01052db:	ff 75 dc             	pushl  -0x24(%ebp)
c01052de:	e8 cb d8 ff ff       	call   c0102bae <free_pages>
c01052e3:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01052e6:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01052ed:	eb 1d                	jmp    c010530c <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c01052ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052f2:	83 e8 0c             	sub    $0xc,%eax
c01052f5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c01052f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01052fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105302:	8b 40 08             	mov    0x8(%eax),%eax
c0105305:	29 c2                	sub    %eax,%edx
c0105307:	89 d0                	mov    %edx,%eax
c0105309:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010530c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010530f:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105312:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105315:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105318:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010531b:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0105322:	75 cb                	jne    c01052ef <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105328:	74 19                	je     c0105343 <default_check+0x546>
c010532a:	68 b2 6f 10 c0       	push   $0xc0106fb2
c010532f:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105334:	68 5c 01 00 00       	push   $0x15c
c0105339:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010533e:	e8 8a b0 ff ff       	call   c01003cd <__panic>
    assert(total == 0);
c0105343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105347:	74 19                	je     c0105362 <default_check+0x565>
c0105349:	68 bd 6f 10 c0       	push   $0xc0106fbd
c010534e:	68 c0 6c 10 c0       	push   $0xc0106cc0
c0105353:	68 5d 01 00 00       	push   $0x15d
c0105358:	68 d5 6c 10 c0       	push   $0xc0106cd5
c010535d:	e8 6b b0 ff ff       	call   c01003cd <__panic>
}
c0105362:	90                   	nop
c0105363:	c9                   	leave  
c0105364:	c3                   	ret    

c0105365 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105365:	55                   	push   %ebp
c0105366:	89 e5                	mov    %esp,%ebp
c0105368:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010536b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105372:	eb 04                	jmp    c0105378 <strlen+0x13>
        cnt ++;
c0105374:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105378:	8b 45 08             	mov    0x8(%ebp),%eax
c010537b:	8d 50 01             	lea    0x1(%eax),%edx
c010537e:	89 55 08             	mov    %edx,0x8(%ebp)
c0105381:	0f b6 00             	movzbl (%eax),%eax
c0105384:	84 c0                	test   %al,%al
c0105386:	75 ec                	jne    c0105374 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010538b:	c9                   	leave  
c010538c:	c3                   	ret    

c010538d <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010538d:	55                   	push   %ebp
c010538e:	89 e5                	mov    %esp,%ebp
c0105390:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010539a:	eb 04                	jmp    c01053a0 <strnlen+0x13>
        cnt ++;
c010539c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01053a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01053a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053a6:	73 10                	jae    c01053b8 <strnlen+0x2b>
c01053a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ab:	8d 50 01             	lea    0x1(%eax),%edx
c01053ae:	89 55 08             	mov    %edx,0x8(%ebp)
c01053b1:	0f b6 00             	movzbl (%eax),%eax
c01053b4:	84 c0                	test   %al,%al
c01053b6:	75 e4                	jne    c010539c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01053b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01053bb:	c9                   	leave  
c01053bc:	c3                   	ret    

c01053bd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01053bd:	55                   	push   %ebp
c01053be:	89 e5                	mov    %esp,%ebp
c01053c0:	57                   	push   %edi
c01053c1:	56                   	push   %esi
c01053c2:	83 ec 20             	sub    $0x20,%esp
c01053c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01053c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01053d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053d7:	89 d1                	mov    %edx,%ecx
c01053d9:	89 c2                	mov    %eax,%edx
c01053db:	89 ce                	mov    %ecx,%esi
c01053dd:	89 d7                	mov    %edx,%edi
c01053df:	ac                   	lods   %ds:(%esi),%al
c01053e0:	aa                   	stos   %al,%es:(%edi)
c01053e1:	84 c0                	test   %al,%al
c01053e3:	75 fa                	jne    c01053df <strcpy+0x22>
c01053e5:	89 fa                	mov    %edi,%edx
c01053e7:	89 f1                	mov    %esi,%ecx
c01053e9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01053ec:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01053ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01053f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01053f5:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01053f6:	83 c4 20             	add    $0x20,%esp
c01053f9:	5e                   	pop    %esi
c01053fa:	5f                   	pop    %edi
c01053fb:	5d                   	pop    %ebp
c01053fc:	c3                   	ret    

c01053fd <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01053fd:	55                   	push   %ebp
c01053fe:	89 e5                	mov    %esp,%ebp
c0105400:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105403:	8b 45 08             	mov    0x8(%ebp),%eax
c0105406:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105409:	eb 21                	jmp    c010542c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010540b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540e:	0f b6 10             	movzbl (%eax),%edx
c0105411:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105414:	88 10                	mov    %dl,(%eax)
c0105416:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105419:	0f b6 00             	movzbl (%eax),%eax
c010541c:	84 c0                	test   %al,%al
c010541e:	74 04                	je     c0105424 <strncpy+0x27>
            src ++;
c0105420:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105424:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105428:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010542c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105430:	75 d9                	jne    c010540b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105432:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105435:	c9                   	leave  
c0105436:	c3                   	ret    

c0105437 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105437:	55                   	push   %ebp
c0105438:	89 e5                	mov    %esp,%ebp
c010543a:	57                   	push   %edi
c010543b:	56                   	push   %esi
c010543c:	83 ec 20             	sub    $0x20,%esp
c010543f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105442:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105445:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105448:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010544b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010544e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105451:	89 d1                	mov    %edx,%ecx
c0105453:	89 c2                	mov    %eax,%edx
c0105455:	89 ce                	mov    %ecx,%esi
c0105457:	89 d7                	mov    %edx,%edi
c0105459:	ac                   	lods   %ds:(%esi),%al
c010545a:	ae                   	scas   %es:(%edi),%al
c010545b:	75 08                	jne    c0105465 <strcmp+0x2e>
c010545d:	84 c0                	test   %al,%al
c010545f:	75 f8                	jne    c0105459 <strcmp+0x22>
c0105461:	31 c0                	xor    %eax,%eax
c0105463:	eb 04                	jmp    c0105469 <strcmp+0x32>
c0105465:	19 c0                	sbb    %eax,%eax
c0105467:	0c 01                	or     $0x1,%al
c0105469:	89 fa                	mov    %edi,%edx
c010546b:	89 f1                	mov    %esi,%ecx
c010546d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105470:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105473:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105476:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105479:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010547a:	83 c4 20             	add    $0x20,%esp
c010547d:	5e                   	pop    %esi
c010547e:	5f                   	pop    %edi
c010547f:	5d                   	pop    %ebp
c0105480:	c3                   	ret    

c0105481 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105481:	55                   	push   %ebp
c0105482:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105484:	eb 0c                	jmp    c0105492 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105486:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010548a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010548e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105492:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105496:	74 1a                	je     c01054b2 <strncmp+0x31>
c0105498:	8b 45 08             	mov    0x8(%ebp),%eax
c010549b:	0f b6 00             	movzbl (%eax),%eax
c010549e:	84 c0                	test   %al,%al
c01054a0:	74 10                	je     c01054b2 <strncmp+0x31>
c01054a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a5:	0f b6 10             	movzbl (%eax),%edx
c01054a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ab:	0f b6 00             	movzbl (%eax),%eax
c01054ae:	38 c2                	cmp    %al,%dl
c01054b0:	74 d4                	je     c0105486 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01054b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054b6:	74 18                	je     c01054d0 <strncmp+0x4f>
c01054b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01054bb:	0f b6 00             	movzbl (%eax),%eax
c01054be:	0f b6 d0             	movzbl %al,%edx
c01054c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c4:	0f b6 00             	movzbl (%eax),%eax
c01054c7:	0f b6 c0             	movzbl %al,%eax
c01054ca:	29 c2                	sub    %eax,%edx
c01054cc:	89 d0                	mov    %edx,%eax
c01054ce:	eb 05                	jmp    c01054d5 <strncmp+0x54>
c01054d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054d5:	5d                   	pop    %ebp
c01054d6:	c3                   	ret    

c01054d7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01054d7:	55                   	push   %ebp
c01054d8:	89 e5                	mov    %esp,%ebp
c01054da:	83 ec 04             	sub    $0x4,%esp
c01054dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054e0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01054e3:	eb 14                	jmp    c01054f9 <strchr+0x22>
        if (*s == c) {
c01054e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e8:	0f b6 00             	movzbl (%eax),%eax
c01054eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01054ee:	75 05                	jne    c01054f5 <strchr+0x1e>
            return (char *)s;
c01054f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f3:	eb 13                	jmp    c0105508 <strchr+0x31>
        }
        s ++;
c01054f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01054f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fc:	0f b6 00             	movzbl (%eax),%eax
c01054ff:	84 c0                	test   %al,%al
c0105501:	75 e2                	jne    c01054e5 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105503:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105508:	c9                   	leave  
c0105509:	c3                   	ret    

c010550a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010550a:	55                   	push   %ebp
c010550b:	89 e5                	mov    %esp,%ebp
c010550d:	83 ec 04             	sub    $0x4,%esp
c0105510:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105513:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105516:	eb 0f                	jmp    c0105527 <strfind+0x1d>
        if (*s == c) {
c0105518:	8b 45 08             	mov    0x8(%ebp),%eax
c010551b:	0f b6 00             	movzbl (%eax),%eax
c010551e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105521:	74 10                	je     c0105533 <strfind+0x29>
            break;
        }
        s ++;
c0105523:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105527:	8b 45 08             	mov    0x8(%ebp),%eax
c010552a:	0f b6 00             	movzbl (%eax),%eax
c010552d:	84 c0                	test   %al,%al
c010552f:	75 e7                	jne    c0105518 <strfind+0xe>
c0105531:	eb 01                	jmp    c0105534 <strfind+0x2a>
        if (*s == c) {
            break;
c0105533:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105534:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105537:	c9                   	leave  
c0105538:	c3                   	ret    

c0105539 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105539:	55                   	push   %ebp
c010553a:	89 e5                	mov    %esp,%ebp
c010553c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010553f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105546:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010554d:	eb 04                	jmp    c0105553 <strtol+0x1a>
        s ++;
c010554f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105553:	8b 45 08             	mov    0x8(%ebp),%eax
c0105556:	0f b6 00             	movzbl (%eax),%eax
c0105559:	3c 20                	cmp    $0x20,%al
c010555b:	74 f2                	je     c010554f <strtol+0x16>
c010555d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105560:	0f b6 00             	movzbl (%eax),%eax
c0105563:	3c 09                	cmp    $0x9,%al
c0105565:	74 e8                	je     c010554f <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105567:	8b 45 08             	mov    0x8(%ebp),%eax
c010556a:	0f b6 00             	movzbl (%eax),%eax
c010556d:	3c 2b                	cmp    $0x2b,%al
c010556f:	75 06                	jne    c0105577 <strtol+0x3e>
        s ++;
c0105571:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105575:	eb 15                	jmp    c010558c <strtol+0x53>
    }
    else if (*s == '-') {
c0105577:	8b 45 08             	mov    0x8(%ebp),%eax
c010557a:	0f b6 00             	movzbl (%eax),%eax
c010557d:	3c 2d                	cmp    $0x2d,%al
c010557f:	75 0b                	jne    c010558c <strtol+0x53>
        s ++, neg = 1;
c0105581:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105585:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010558c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105590:	74 06                	je     c0105598 <strtol+0x5f>
c0105592:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105596:	75 24                	jne    c01055bc <strtol+0x83>
c0105598:	8b 45 08             	mov    0x8(%ebp),%eax
c010559b:	0f b6 00             	movzbl (%eax),%eax
c010559e:	3c 30                	cmp    $0x30,%al
c01055a0:	75 1a                	jne    c01055bc <strtol+0x83>
c01055a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a5:	83 c0 01             	add    $0x1,%eax
c01055a8:	0f b6 00             	movzbl (%eax),%eax
c01055ab:	3c 78                	cmp    $0x78,%al
c01055ad:	75 0d                	jne    c01055bc <strtol+0x83>
        s += 2, base = 16;
c01055af:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01055b3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01055ba:	eb 2a                	jmp    c01055e6 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01055bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055c0:	75 17                	jne    c01055d9 <strtol+0xa0>
c01055c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c5:	0f b6 00             	movzbl (%eax),%eax
c01055c8:	3c 30                	cmp    $0x30,%al
c01055ca:	75 0d                	jne    c01055d9 <strtol+0xa0>
        s ++, base = 8;
c01055cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01055d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01055d7:	eb 0d                	jmp    c01055e6 <strtol+0xad>
    }
    else if (base == 0) {
c01055d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055dd:	75 07                	jne    c01055e6 <strtol+0xad>
        base = 10;
c01055df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01055e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e9:	0f b6 00             	movzbl (%eax),%eax
c01055ec:	3c 2f                	cmp    $0x2f,%al
c01055ee:	7e 1b                	jle    c010560b <strtol+0xd2>
c01055f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f3:	0f b6 00             	movzbl (%eax),%eax
c01055f6:	3c 39                	cmp    $0x39,%al
c01055f8:	7f 11                	jg     c010560b <strtol+0xd2>
            dig = *s - '0';
c01055fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fd:	0f b6 00             	movzbl (%eax),%eax
c0105600:	0f be c0             	movsbl %al,%eax
c0105603:	83 e8 30             	sub    $0x30,%eax
c0105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105609:	eb 48                	jmp    c0105653 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010560b:	8b 45 08             	mov    0x8(%ebp),%eax
c010560e:	0f b6 00             	movzbl (%eax),%eax
c0105611:	3c 60                	cmp    $0x60,%al
c0105613:	7e 1b                	jle    c0105630 <strtol+0xf7>
c0105615:	8b 45 08             	mov    0x8(%ebp),%eax
c0105618:	0f b6 00             	movzbl (%eax),%eax
c010561b:	3c 7a                	cmp    $0x7a,%al
c010561d:	7f 11                	jg     c0105630 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010561f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105622:	0f b6 00             	movzbl (%eax),%eax
c0105625:	0f be c0             	movsbl %al,%eax
c0105628:	83 e8 57             	sub    $0x57,%eax
c010562b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010562e:	eb 23                	jmp    c0105653 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105630:	8b 45 08             	mov    0x8(%ebp),%eax
c0105633:	0f b6 00             	movzbl (%eax),%eax
c0105636:	3c 40                	cmp    $0x40,%al
c0105638:	7e 3c                	jle    c0105676 <strtol+0x13d>
c010563a:	8b 45 08             	mov    0x8(%ebp),%eax
c010563d:	0f b6 00             	movzbl (%eax),%eax
c0105640:	3c 5a                	cmp    $0x5a,%al
c0105642:	7f 32                	jg     c0105676 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105644:	8b 45 08             	mov    0x8(%ebp),%eax
c0105647:	0f b6 00             	movzbl (%eax),%eax
c010564a:	0f be c0             	movsbl %al,%eax
c010564d:	83 e8 37             	sub    $0x37,%eax
c0105650:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105656:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105659:	7d 1a                	jge    c0105675 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010565b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010565f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105662:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105666:	89 c2                	mov    %eax,%edx
c0105668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010566b:	01 d0                	add    %edx,%eax
c010566d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105670:	e9 71 ff ff ff       	jmp    c01055e6 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105675:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105676:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010567a:	74 08                	je     c0105684 <strtol+0x14b>
        *endptr = (char *) s;
c010567c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105682:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105684:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105688:	74 07                	je     c0105691 <strtol+0x158>
c010568a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010568d:	f7 d8                	neg    %eax
c010568f:	eb 03                	jmp    c0105694 <strtol+0x15b>
c0105691:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105694:	c9                   	leave  
c0105695:	c3                   	ret    

c0105696 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105696:	55                   	push   %ebp
c0105697:	89 e5                	mov    %esp,%ebp
c0105699:	57                   	push   %edi
c010569a:	83 ec 24             	sub    $0x24,%esp
c010569d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01056a3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01056a7:	8b 55 08             	mov    0x8(%ebp),%edx
c01056aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01056ad:	88 45 f7             	mov    %al,-0x9(%ebp)
c01056b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01056b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01056b6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01056b9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01056bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01056c0:	89 d7                	mov    %edx,%edi
c01056c2:	f3 aa                	rep stos %al,%es:(%edi)
c01056c4:	89 fa                	mov    %edi,%edx
c01056c6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01056c9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01056cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056cf:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01056d0:	83 c4 24             	add    $0x24,%esp
c01056d3:	5f                   	pop    %edi
c01056d4:	5d                   	pop    %ebp
c01056d5:	c3                   	ret    

c01056d6 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01056d6:	55                   	push   %ebp
c01056d7:	89 e5                	mov    %esp,%ebp
c01056d9:	57                   	push   %edi
c01056da:	56                   	push   %esi
c01056db:	53                   	push   %ebx
c01056dc:	83 ec 30             	sub    $0x30,%esp
c01056df:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01056ee:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01056f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01056f7:	73 42                	jae    c010573b <memmove+0x65>
c01056f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105702:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105705:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105708:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010570b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010570e:	c1 e8 02             	shr    $0x2,%eax
c0105711:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105716:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105719:	89 d7                	mov    %edx,%edi
c010571b:	89 c6                	mov    %eax,%esi
c010571d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010571f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105722:	83 e1 03             	and    $0x3,%ecx
c0105725:	74 02                	je     c0105729 <memmove+0x53>
c0105727:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105729:	89 f0                	mov    %esi,%eax
c010572b:	89 fa                	mov    %edi,%edx
c010572d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105730:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105733:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105739:	eb 36                	jmp    c0105771 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010573b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010573e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105741:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105744:	01 c2                	add    %eax,%edx
c0105746:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105749:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010574c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010574f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105752:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105755:	89 c1                	mov    %eax,%ecx
c0105757:	89 d8                	mov    %ebx,%eax
c0105759:	89 d6                	mov    %edx,%esi
c010575b:	89 c7                	mov    %eax,%edi
c010575d:	fd                   	std    
c010575e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105760:	fc                   	cld    
c0105761:	89 f8                	mov    %edi,%eax
c0105763:	89 f2                	mov    %esi,%edx
c0105765:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105768:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010576b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010576e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105771:	83 c4 30             	add    $0x30,%esp
c0105774:	5b                   	pop    %ebx
c0105775:	5e                   	pop    %esi
c0105776:	5f                   	pop    %edi
c0105777:	5d                   	pop    %ebp
c0105778:	c3                   	ret    

c0105779 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105779:	55                   	push   %ebp
c010577a:	89 e5                	mov    %esp,%ebp
c010577c:	57                   	push   %edi
c010577d:	56                   	push   %esi
c010577e:	83 ec 20             	sub    $0x20,%esp
c0105781:	8b 45 08             	mov    0x8(%ebp),%eax
c0105784:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105787:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010578d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105790:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105793:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105796:	c1 e8 02             	shr    $0x2,%eax
c0105799:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010579b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a1:	89 d7                	mov    %edx,%edi
c01057a3:	89 c6                	mov    %eax,%esi
c01057a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01057a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01057aa:	83 e1 03             	and    $0x3,%ecx
c01057ad:	74 02                	je     c01057b1 <memcpy+0x38>
c01057af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057b1:	89 f0                	mov    %esi,%eax
c01057b3:	89 fa                	mov    %edi,%edx
c01057b5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01057b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01057bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01057be:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01057c1:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01057c2:	83 c4 20             	add    $0x20,%esp
c01057c5:	5e                   	pop    %esi
c01057c6:	5f                   	pop    %edi
c01057c7:	5d                   	pop    %ebp
c01057c8:	c3                   	ret    

c01057c9 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01057c9:	55                   	push   %ebp
c01057ca:	89 e5                	mov    %esp,%ebp
c01057cc:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01057cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01057d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01057db:	eb 30                	jmp    c010580d <memcmp+0x44>
        if (*s1 != *s2) {
c01057dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057e0:	0f b6 10             	movzbl (%eax),%edx
c01057e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01057e6:	0f b6 00             	movzbl (%eax),%eax
c01057e9:	38 c2                	cmp    %al,%dl
c01057eb:	74 18                	je     c0105805 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01057ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057f0:	0f b6 00             	movzbl (%eax),%eax
c01057f3:	0f b6 d0             	movzbl %al,%edx
c01057f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01057f9:	0f b6 00             	movzbl (%eax),%eax
c01057fc:	0f b6 c0             	movzbl %al,%eax
c01057ff:	29 c2                	sub    %eax,%edx
c0105801:	89 d0                	mov    %edx,%eax
c0105803:	eb 1a                	jmp    c010581f <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105805:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105809:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010580d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105810:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105813:	89 55 10             	mov    %edx,0x10(%ebp)
c0105816:	85 c0                	test   %eax,%eax
c0105818:	75 c3                	jne    c01057dd <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010581a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010581f:	c9                   	leave  
c0105820:	c3                   	ret    

c0105821 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105821:	55                   	push   %ebp
c0105822:	89 e5                	mov    %esp,%ebp
c0105824:	83 ec 38             	sub    $0x38,%esp
c0105827:	8b 45 10             	mov    0x10(%ebp),%eax
c010582a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010582d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105833:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105836:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105839:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010583c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010583f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105845:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105848:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010584b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010584e:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105851:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105854:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010585b:	74 1c                	je     c0105879 <printnum+0x58>
c010585d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105860:	ba 00 00 00 00       	mov    $0x0,%edx
c0105865:	f7 75 e4             	divl   -0x1c(%ebp)
c0105868:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010586b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010586e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105873:	f7 75 e4             	divl   -0x1c(%ebp)
c0105876:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105879:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010587c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010587f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105882:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105885:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105888:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010588b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010588e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105891:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105894:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105897:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010589a:	8b 45 18             	mov    0x18(%ebp),%eax
c010589d:	ba 00 00 00 00       	mov    $0x0,%edx
c01058a2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01058a5:	77 41                	ja     c01058e8 <printnum+0xc7>
c01058a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01058aa:	72 05                	jb     c01058b1 <printnum+0x90>
c01058ac:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01058af:	77 37                	ja     c01058e8 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01058b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01058b4:	83 e8 01             	sub    $0x1,%eax
c01058b7:	83 ec 04             	sub    $0x4,%esp
c01058ba:	ff 75 20             	pushl  0x20(%ebp)
c01058bd:	50                   	push   %eax
c01058be:	ff 75 18             	pushl  0x18(%ebp)
c01058c1:	ff 75 ec             	pushl  -0x14(%ebp)
c01058c4:	ff 75 e8             	pushl  -0x18(%ebp)
c01058c7:	ff 75 0c             	pushl  0xc(%ebp)
c01058ca:	ff 75 08             	pushl  0x8(%ebp)
c01058cd:	e8 4f ff ff ff       	call   c0105821 <printnum>
c01058d2:	83 c4 20             	add    $0x20,%esp
c01058d5:	eb 1b                	jmp    c01058f2 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01058d7:	83 ec 08             	sub    $0x8,%esp
c01058da:	ff 75 0c             	pushl  0xc(%ebp)
c01058dd:	ff 75 20             	pushl  0x20(%ebp)
c01058e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e3:	ff d0                	call   *%eax
c01058e5:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01058e8:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01058ec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01058f0:	7f e5                	jg     c01058d7 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01058f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058f5:	05 78 70 10 c0       	add    $0xc0107078,%eax
c01058fa:	0f b6 00             	movzbl (%eax),%eax
c01058fd:	0f be c0             	movsbl %al,%eax
c0105900:	83 ec 08             	sub    $0x8,%esp
c0105903:	ff 75 0c             	pushl  0xc(%ebp)
c0105906:	50                   	push   %eax
c0105907:	8b 45 08             	mov    0x8(%ebp),%eax
c010590a:	ff d0                	call   *%eax
c010590c:	83 c4 10             	add    $0x10,%esp
}
c010590f:	90                   	nop
c0105910:	c9                   	leave  
c0105911:	c3                   	ret    

c0105912 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105912:	55                   	push   %ebp
c0105913:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105919:	7e 14                	jle    c010592f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010591b:	8b 45 08             	mov    0x8(%ebp),%eax
c010591e:	8b 00                	mov    (%eax),%eax
c0105920:	8d 48 08             	lea    0x8(%eax),%ecx
c0105923:	8b 55 08             	mov    0x8(%ebp),%edx
c0105926:	89 0a                	mov    %ecx,(%edx)
c0105928:	8b 50 04             	mov    0x4(%eax),%edx
c010592b:	8b 00                	mov    (%eax),%eax
c010592d:	eb 30                	jmp    c010595f <getuint+0x4d>
    }
    else if (lflag) {
c010592f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105933:	74 16                	je     c010594b <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105935:	8b 45 08             	mov    0x8(%ebp),%eax
c0105938:	8b 00                	mov    (%eax),%eax
c010593a:	8d 48 04             	lea    0x4(%eax),%ecx
c010593d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105940:	89 0a                	mov    %ecx,(%edx)
c0105942:	8b 00                	mov    (%eax),%eax
c0105944:	ba 00 00 00 00       	mov    $0x0,%edx
c0105949:	eb 14                	jmp    c010595f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010594b:	8b 45 08             	mov    0x8(%ebp),%eax
c010594e:	8b 00                	mov    (%eax),%eax
c0105950:	8d 48 04             	lea    0x4(%eax),%ecx
c0105953:	8b 55 08             	mov    0x8(%ebp),%edx
c0105956:	89 0a                	mov    %ecx,(%edx)
c0105958:	8b 00                	mov    (%eax),%eax
c010595a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010595f:	5d                   	pop    %ebp
c0105960:	c3                   	ret    

c0105961 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105961:	55                   	push   %ebp
c0105962:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105964:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105968:	7e 14                	jle    c010597e <getint+0x1d>
        return va_arg(*ap, long long);
c010596a:	8b 45 08             	mov    0x8(%ebp),%eax
c010596d:	8b 00                	mov    (%eax),%eax
c010596f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105972:	8b 55 08             	mov    0x8(%ebp),%edx
c0105975:	89 0a                	mov    %ecx,(%edx)
c0105977:	8b 50 04             	mov    0x4(%eax),%edx
c010597a:	8b 00                	mov    (%eax),%eax
c010597c:	eb 28                	jmp    c01059a6 <getint+0x45>
    }
    else if (lflag) {
c010597e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105982:	74 12                	je     c0105996 <getint+0x35>
        return va_arg(*ap, long);
c0105984:	8b 45 08             	mov    0x8(%ebp),%eax
c0105987:	8b 00                	mov    (%eax),%eax
c0105989:	8d 48 04             	lea    0x4(%eax),%ecx
c010598c:	8b 55 08             	mov    0x8(%ebp),%edx
c010598f:	89 0a                	mov    %ecx,(%edx)
c0105991:	8b 00                	mov    (%eax),%eax
c0105993:	99                   	cltd   
c0105994:	eb 10                	jmp    c01059a6 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105996:	8b 45 08             	mov    0x8(%ebp),%eax
c0105999:	8b 00                	mov    (%eax),%eax
c010599b:	8d 48 04             	lea    0x4(%eax),%ecx
c010599e:	8b 55 08             	mov    0x8(%ebp),%edx
c01059a1:	89 0a                	mov    %ecx,(%edx)
c01059a3:	8b 00                	mov    (%eax),%eax
c01059a5:	99                   	cltd   
    }
}
c01059a6:	5d                   	pop    %ebp
c01059a7:	c3                   	ret    

c01059a8 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01059a8:	55                   	push   %ebp
c01059a9:	89 e5                	mov    %esp,%ebp
c01059ab:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01059ae:	8d 45 14             	lea    0x14(%ebp),%eax
c01059b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059b7:	50                   	push   %eax
c01059b8:	ff 75 10             	pushl  0x10(%ebp)
c01059bb:	ff 75 0c             	pushl  0xc(%ebp)
c01059be:	ff 75 08             	pushl  0x8(%ebp)
c01059c1:	e8 06 00 00 00       	call   c01059cc <vprintfmt>
c01059c6:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01059c9:	90                   	nop
c01059ca:	c9                   	leave  
c01059cb:	c3                   	ret    

c01059cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01059cc:	55                   	push   %ebp
c01059cd:	89 e5                	mov    %esp,%ebp
c01059cf:	56                   	push   %esi
c01059d0:	53                   	push   %ebx
c01059d1:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059d4:	eb 17                	jmp    c01059ed <vprintfmt+0x21>
            if (ch == '\0') {
c01059d6:	85 db                	test   %ebx,%ebx
c01059d8:	0f 84 8e 03 00 00    	je     c0105d6c <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01059de:	83 ec 08             	sub    $0x8,%esp
c01059e1:	ff 75 0c             	pushl  0xc(%ebp)
c01059e4:	53                   	push   %ebx
c01059e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e8:	ff d0                	call   *%eax
c01059ea:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01059f0:	8d 50 01             	lea    0x1(%eax),%edx
c01059f3:	89 55 10             	mov    %edx,0x10(%ebp)
c01059f6:	0f b6 00             	movzbl (%eax),%eax
c01059f9:	0f b6 d8             	movzbl %al,%ebx
c01059fc:	83 fb 25             	cmp    $0x25,%ebx
c01059ff:	75 d5                	jne    c01059d6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105a01:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105a05:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105a12:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a1c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105a1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a22:	8d 50 01             	lea    0x1(%eax),%edx
c0105a25:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a28:	0f b6 00             	movzbl (%eax),%eax
c0105a2b:	0f b6 d8             	movzbl %al,%ebx
c0105a2e:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105a31:	83 f8 55             	cmp    $0x55,%eax
c0105a34:	0f 87 05 03 00 00    	ja     c0105d3f <vprintfmt+0x373>
c0105a3a:	8b 04 85 9c 70 10 c0 	mov    -0x3fef8f64(,%eax,4),%eax
c0105a41:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105a43:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105a47:	eb d6                	jmp    c0105a1f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105a49:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105a4d:	eb d0                	jmp    c0105a1f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105a4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a59:	89 d0                	mov    %edx,%eax
c0105a5b:	c1 e0 02             	shl    $0x2,%eax
c0105a5e:	01 d0                	add    %edx,%eax
c0105a60:	01 c0                	add    %eax,%eax
c0105a62:	01 d8                	add    %ebx,%eax
c0105a64:	83 e8 30             	sub    $0x30,%eax
c0105a67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105a6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a6d:	0f b6 00             	movzbl (%eax),%eax
c0105a70:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105a73:	83 fb 2f             	cmp    $0x2f,%ebx
c0105a76:	7e 39                	jle    c0105ab1 <vprintfmt+0xe5>
c0105a78:	83 fb 39             	cmp    $0x39,%ebx
c0105a7b:	7f 34                	jg     c0105ab1 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105a7d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105a81:	eb d3                	jmp    c0105a56 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105a83:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a86:	8d 50 04             	lea    0x4(%eax),%edx
c0105a89:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a8c:	8b 00                	mov    (%eax),%eax
c0105a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105a91:	eb 1f                	jmp    c0105ab2 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105a93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a97:	79 86                	jns    c0105a1f <vprintfmt+0x53>
                width = 0;
c0105a99:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105aa0:	e9 7a ff ff ff       	jmp    c0105a1f <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105aa5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105aac:	e9 6e ff ff ff       	jmp    c0105a1f <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0105ab1:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0105ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ab6:	0f 89 63 ff ff ff    	jns    c0105a1f <vprintfmt+0x53>
                width = precision, precision = -1;
c0105abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105abf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ac2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105ac9:	e9 51 ff ff ff       	jmp    c0105a1f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105ace:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105ad2:	e9 48 ff ff ff       	jmp    c0105a1f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105ad7:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ada:	8d 50 04             	lea    0x4(%eax),%edx
c0105add:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ae0:	8b 00                	mov    (%eax),%eax
c0105ae2:	83 ec 08             	sub    $0x8,%esp
c0105ae5:	ff 75 0c             	pushl  0xc(%ebp)
c0105ae8:	50                   	push   %eax
c0105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aec:	ff d0                	call   *%eax
c0105aee:	83 c4 10             	add    $0x10,%esp
            break;
c0105af1:	e9 71 02 00 00       	jmp    c0105d67 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105af6:	8b 45 14             	mov    0x14(%ebp),%eax
c0105af9:	8d 50 04             	lea    0x4(%eax),%edx
c0105afc:	89 55 14             	mov    %edx,0x14(%ebp)
c0105aff:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105b01:	85 db                	test   %ebx,%ebx
c0105b03:	79 02                	jns    c0105b07 <vprintfmt+0x13b>
                err = -err;
c0105b05:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105b07:	83 fb 06             	cmp    $0x6,%ebx
c0105b0a:	7f 0b                	jg     c0105b17 <vprintfmt+0x14b>
c0105b0c:	8b 34 9d 5c 70 10 c0 	mov    -0x3fef8fa4(,%ebx,4),%esi
c0105b13:	85 f6                	test   %esi,%esi
c0105b15:	75 19                	jne    c0105b30 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105b17:	53                   	push   %ebx
c0105b18:	68 89 70 10 c0       	push   $0xc0107089
c0105b1d:	ff 75 0c             	pushl  0xc(%ebp)
c0105b20:	ff 75 08             	pushl  0x8(%ebp)
c0105b23:	e8 80 fe ff ff       	call   c01059a8 <printfmt>
c0105b28:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105b2b:	e9 37 02 00 00       	jmp    c0105d67 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105b30:	56                   	push   %esi
c0105b31:	68 92 70 10 c0       	push   $0xc0107092
c0105b36:	ff 75 0c             	pushl  0xc(%ebp)
c0105b39:	ff 75 08             	pushl  0x8(%ebp)
c0105b3c:	e8 67 fe ff ff       	call   c01059a8 <printfmt>
c0105b41:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105b44:	e9 1e 02 00 00       	jmp    c0105d67 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105b49:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b4c:	8d 50 04             	lea    0x4(%eax),%edx
c0105b4f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b52:	8b 30                	mov    (%eax),%esi
c0105b54:	85 f6                	test   %esi,%esi
c0105b56:	75 05                	jne    c0105b5d <vprintfmt+0x191>
                p = "(null)";
c0105b58:	be 95 70 10 c0       	mov    $0xc0107095,%esi
            }
            if (width > 0 && padc != '-') {
c0105b5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b61:	7e 76                	jle    c0105bd9 <vprintfmt+0x20d>
c0105b63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105b67:	74 70                	je     c0105bd9 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b6c:	83 ec 08             	sub    $0x8,%esp
c0105b6f:	50                   	push   %eax
c0105b70:	56                   	push   %esi
c0105b71:	e8 17 f8 ff ff       	call   c010538d <strnlen>
c0105b76:	83 c4 10             	add    $0x10,%esp
c0105b79:	89 c2                	mov    %eax,%edx
c0105b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b7e:	29 d0                	sub    %edx,%eax
c0105b80:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b83:	eb 17                	jmp    c0105b9c <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105b85:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105b89:	83 ec 08             	sub    $0x8,%esp
c0105b8c:	ff 75 0c             	pushl  0xc(%ebp)
c0105b8f:	50                   	push   %eax
c0105b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b93:	ff d0                	call   *%eax
c0105b95:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105b98:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ba0:	7f e3                	jg     c0105b85 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ba2:	eb 35                	jmp    c0105bd9 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105ba4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105ba8:	74 1c                	je     c0105bc6 <vprintfmt+0x1fa>
c0105baa:	83 fb 1f             	cmp    $0x1f,%ebx
c0105bad:	7e 05                	jle    c0105bb4 <vprintfmt+0x1e8>
c0105baf:	83 fb 7e             	cmp    $0x7e,%ebx
c0105bb2:	7e 12                	jle    c0105bc6 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105bb4:	83 ec 08             	sub    $0x8,%esp
c0105bb7:	ff 75 0c             	pushl  0xc(%ebp)
c0105bba:	6a 3f                	push   $0x3f
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	ff d0                	call   *%eax
c0105bc1:	83 c4 10             	add    $0x10,%esp
c0105bc4:	eb 0f                	jmp    c0105bd5 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105bc6:	83 ec 08             	sub    $0x8,%esp
c0105bc9:	ff 75 0c             	pushl  0xc(%ebp)
c0105bcc:	53                   	push   %ebx
c0105bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd0:	ff d0                	call   *%eax
c0105bd2:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105bd5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105bd9:	89 f0                	mov    %esi,%eax
c0105bdb:	8d 70 01             	lea    0x1(%eax),%esi
c0105bde:	0f b6 00             	movzbl (%eax),%eax
c0105be1:	0f be d8             	movsbl %al,%ebx
c0105be4:	85 db                	test   %ebx,%ebx
c0105be6:	74 26                	je     c0105c0e <vprintfmt+0x242>
c0105be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105bec:	78 b6                	js     c0105ba4 <vprintfmt+0x1d8>
c0105bee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105bf6:	79 ac                	jns    c0105ba4 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105bf8:	eb 14                	jmp    c0105c0e <vprintfmt+0x242>
                putch(' ', putdat);
c0105bfa:	83 ec 08             	sub    $0x8,%esp
c0105bfd:	ff 75 0c             	pushl  0xc(%ebp)
c0105c00:	6a 20                	push   $0x20
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	ff d0                	call   *%eax
c0105c07:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105c0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c12:	7f e6                	jg     c0105bfa <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0105c14:	e9 4e 01 00 00       	jmp    c0105d67 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105c19:	83 ec 08             	sub    $0x8,%esp
c0105c1c:	ff 75 e0             	pushl  -0x20(%ebp)
c0105c1f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c22:	50                   	push   %eax
c0105c23:	e8 39 fd ff ff       	call   c0105961 <getint>
c0105c28:	83 c4 10             	add    $0x10,%esp
c0105c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c37:	85 d2                	test   %edx,%edx
c0105c39:	79 23                	jns    c0105c5e <vprintfmt+0x292>
                putch('-', putdat);
c0105c3b:	83 ec 08             	sub    $0x8,%esp
c0105c3e:	ff 75 0c             	pushl  0xc(%ebp)
c0105c41:	6a 2d                	push   $0x2d
c0105c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c46:	ff d0                	call   *%eax
c0105c48:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c51:	f7 d8                	neg    %eax
c0105c53:	83 d2 00             	adc    $0x0,%edx
c0105c56:	f7 da                	neg    %edx
c0105c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105c5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105c65:	e9 9f 00 00 00       	jmp    c0105d09 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105c6a:	83 ec 08             	sub    $0x8,%esp
c0105c6d:	ff 75 e0             	pushl  -0x20(%ebp)
c0105c70:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c73:	50                   	push   %eax
c0105c74:	e8 99 fc ff ff       	call   c0105912 <getuint>
c0105c79:	83 c4 10             	add    $0x10,%esp
c0105c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105c82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105c89:	eb 7e                	jmp    c0105d09 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105c8b:	83 ec 08             	sub    $0x8,%esp
c0105c8e:	ff 75 e0             	pushl  -0x20(%ebp)
c0105c91:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c94:	50                   	push   %eax
c0105c95:	e8 78 fc ff ff       	call   c0105912 <getuint>
c0105c9a:	83 c4 10             	add    $0x10,%esp
c0105c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ca0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105ca3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105caa:	eb 5d                	jmp    c0105d09 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105cac:	83 ec 08             	sub    $0x8,%esp
c0105caf:	ff 75 0c             	pushl  0xc(%ebp)
c0105cb2:	6a 30                	push   $0x30
c0105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb7:	ff d0                	call   *%eax
c0105cb9:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105cbc:	83 ec 08             	sub    $0x8,%esp
c0105cbf:	ff 75 0c             	pushl  0xc(%ebp)
c0105cc2:	6a 78                	push   $0x78
c0105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc7:	ff d0                	call   *%eax
c0105cc9:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105ccc:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ccf:	8d 50 04             	lea    0x4(%eax),%edx
c0105cd2:	89 55 14             	mov    %edx,0x14(%ebp)
c0105cd5:	8b 00                	mov    (%eax),%eax
c0105cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ce1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105ce8:	eb 1f                	jmp    c0105d09 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105cea:	83 ec 08             	sub    $0x8,%esp
c0105ced:	ff 75 e0             	pushl  -0x20(%ebp)
c0105cf0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105cf3:	50                   	push   %eax
c0105cf4:	e8 19 fc ff ff       	call   c0105912 <getuint>
c0105cf9:	83 c4 10             	add    $0x10,%esp
c0105cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105d02:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105d09:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d10:	83 ec 04             	sub    $0x4,%esp
c0105d13:	52                   	push   %edx
c0105d14:	ff 75 e8             	pushl  -0x18(%ebp)
c0105d17:	50                   	push   %eax
c0105d18:	ff 75 f4             	pushl  -0xc(%ebp)
c0105d1b:	ff 75 f0             	pushl  -0x10(%ebp)
c0105d1e:	ff 75 0c             	pushl  0xc(%ebp)
c0105d21:	ff 75 08             	pushl  0x8(%ebp)
c0105d24:	e8 f8 fa ff ff       	call   c0105821 <printnum>
c0105d29:	83 c4 20             	add    $0x20,%esp
            break;
c0105d2c:	eb 39                	jmp    c0105d67 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105d2e:	83 ec 08             	sub    $0x8,%esp
c0105d31:	ff 75 0c             	pushl  0xc(%ebp)
c0105d34:	53                   	push   %ebx
c0105d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d38:	ff d0                	call   *%eax
c0105d3a:	83 c4 10             	add    $0x10,%esp
            break;
c0105d3d:	eb 28                	jmp    c0105d67 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105d3f:	83 ec 08             	sub    $0x8,%esp
c0105d42:	ff 75 0c             	pushl  0xc(%ebp)
c0105d45:	6a 25                	push   $0x25
c0105d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4a:	ff d0                	call   *%eax
c0105d4c:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105d4f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105d53:	eb 04                	jmp    c0105d59 <vprintfmt+0x38d>
c0105d55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105d59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d5c:	83 e8 01             	sub    $0x1,%eax
c0105d5f:	0f b6 00             	movzbl (%eax),%eax
c0105d62:	3c 25                	cmp    $0x25,%al
c0105d64:	75 ef                	jne    c0105d55 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105d66:	90                   	nop
        }
    }
c0105d67:	e9 68 fc ff ff       	jmp    c01059d4 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105d6c:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105d70:	5b                   	pop    %ebx
c0105d71:	5e                   	pop    %esi
c0105d72:	5d                   	pop    %ebp
c0105d73:	c3                   	ret    

c0105d74 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105d74:	55                   	push   %ebp
c0105d75:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105d77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d7a:	8b 40 08             	mov    0x8(%eax),%eax
c0105d7d:	8d 50 01             	lea    0x1(%eax),%edx
c0105d80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d83:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d89:	8b 10                	mov    (%eax),%edx
c0105d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d8e:	8b 40 04             	mov    0x4(%eax),%eax
c0105d91:	39 c2                	cmp    %eax,%edx
c0105d93:	73 12                	jae    c0105da7 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105d95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d98:	8b 00                	mov    (%eax),%eax
c0105d9a:	8d 48 01             	lea    0x1(%eax),%ecx
c0105d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105da0:	89 0a                	mov    %ecx,(%edx)
c0105da2:	8b 55 08             	mov    0x8(%ebp),%edx
c0105da5:	88 10                	mov    %dl,(%eax)
    }
}
c0105da7:	90                   	nop
c0105da8:	5d                   	pop    %ebp
c0105da9:	c3                   	ret    

c0105daa <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105daa:	55                   	push   %ebp
c0105dab:	89 e5                	mov    %esp,%ebp
c0105dad:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105db0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105db9:	50                   	push   %eax
c0105dba:	ff 75 10             	pushl  0x10(%ebp)
c0105dbd:	ff 75 0c             	pushl  0xc(%ebp)
c0105dc0:	ff 75 08             	pushl  0x8(%ebp)
c0105dc3:	e8 0b 00 00 00       	call   c0105dd3 <vsnprintf>
c0105dc8:	83 c4 10             	add    $0x10,%esp
c0105dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105dd1:	c9                   	leave  
c0105dd2:	c3                   	ret    

c0105dd3 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105dd3:	55                   	push   %ebp
c0105dd4:	89 e5                	mov    %esp,%ebp
c0105dd6:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de8:	01 d0                	add    %edx,%eax
c0105dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105df4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105df8:	74 0a                	je     c0105e04 <vsnprintf+0x31>
c0105dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e00:	39 c2                	cmp    %eax,%edx
c0105e02:	76 07                	jbe    c0105e0b <vsnprintf+0x38>
        return -E_INVAL;
c0105e04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105e09:	eb 20                	jmp    c0105e2b <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105e0b:	ff 75 14             	pushl  0x14(%ebp)
c0105e0e:	ff 75 10             	pushl  0x10(%ebp)
c0105e11:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105e14:	50                   	push   %eax
c0105e15:	68 74 5d 10 c0       	push   $0xc0105d74
c0105e1a:	e8 ad fb ff ff       	call   c01059cc <vprintfmt>
c0105e1f:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e25:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105e2b:	c9                   	leave  
c0105e2c:	c3                   	ret    
