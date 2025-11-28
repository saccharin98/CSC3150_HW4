
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002917          	auipc	s2,0x2
      12:	ff293903          	ld	s2,-14(s2) # 2000 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	e40080e7          	jalr	-448(ra) # e56 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	2dc50513          	addi	a0,a0,732 # 1300 <malloc+0xe8>
      2c:	00001097          	auipc	ra,0x1
      30:	134080e7          	jalr	308(ra) # 1160 <printf>
  exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	da0080e7          	jalr	-608(ra) # dd6 <exit>

000000000000003e <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4705                	li	a4,1
      48:	4781                	li	a5,0
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
    if (i < PGSIZE + (PGSIZE/2)) {
      4a:	6685                	lui	a3,0x1
      4c:	7ff68693          	addi	a3,a3,2047 # 17ff <malloc+0x5e7>
  for (i = 0; i < PGSIZE*2; i++) {
      50:	6889                	lui	a7,0x2
      if (p[i] != 'A') {
      52:	04100813          	li	a6,65
      56:	a819                	j	6c <_v1+0x2e>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else {
      if (p[i] != 0) {
      58:	00054603          	lbu	a2,0(a0)
      5c:	e221                	bnez	a2,9c <_v1+0x5e>
  for (i = 0; i < PGSIZE*2; i++) {
      5e:	0007061b          	sext.w	a2,a4
      62:	05165d63          	bge	a2,a7,bc <_v1+0x7e>
      66:	2785                	addiw	a5,a5,1
      68:	2705                	addiw	a4,a4,1
      6a:	0505                	addi	a0,a0,1
      6c:	0007859b          	sext.w	a1,a5
    if (i < PGSIZE + (PGSIZE/2)) {
      70:	feb6c4e3          	blt	a3,a1,58 <_v1+0x1a>
      if (p[i] != 'A') {
      74:	00054603          	lbu	a2,0(a0)
      78:	ff0607e3          	beq	a2,a6,66 <_v1+0x28>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7c:	00001517          	auipc	a0,0x1
      80:	2ac50513          	addi	a0,a0,684 # 1328 <malloc+0x110>
      84:	00001097          	auipc	ra,0x1
      88:	0dc080e7          	jalr	220(ra) # 1160 <printf>
        err("v1 mismatch (1)");
      8c:	00001517          	auipc	a0,0x1
      90:	2c450513          	addi	a0,a0,708 # 1350 <malloc+0x138>
      94:	00000097          	auipc	ra,0x0
      98:	f6c080e7          	jalr	-148(ra) # 0 <err>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9c:	00001517          	auipc	a0,0x1
      a0:	2c450513          	addi	a0,a0,708 # 1360 <malloc+0x148>
      a4:	00001097          	auipc	ra,0x1
      a8:	0bc080e7          	jalr	188(ra) # 1160 <printf>
        err("v1 mismatch (2)");
      ac:	00001517          	auipc	a0,0x1
      b0:	2dc50513          	addi	a0,a0,732 # 1388 <malloc+0x170>
      b4:	00000097          	auipc	ra,0x0
      b8:	f4c080e7          	jalr	-180(ra) # 0 <err>
      }
    }
  }
}
      bc:	60a2                	ld	ra,8(sp)
      be:	6402                	ld	s0,0(sp)
      c0:	0141                	addi	sp,sp,16
      c2:	8082                	ret

00000000000000c4 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      c4:	7179                	addi	sp,sp,-48
      c6:	f406                	sd	ra,40(sp)
      c8:	f022                	sd	s0,32(sp)
      ca:	ec26                	sd	s1,24(sp)
      cc:	e84a                	sd	s2,16(sp)
      ce:	e44e                	sd	s3,8(sp)
      d0:	1800                	addi	s0,sp,48
      d2:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      d4:	00001097          	auipc	ra,0x1
      d8:	d52080e7          	jalr	-686(ra) # e26 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      dc:	20100593          	li	a1,513
      e0:	8526                	mv	a0,s1
      e2:	00001097          	auipc	ra,0x1
      e6:	d34080e7          	jalr	-716(ra) # e16 <open>
  if (fd == -1)
      ea:	57fd                	li	a5,-1
      ec:	06f50163          	beq	a0,a5,14e <makefile+0x8a>
      f0:	892a                	mv	s2,a0
    err("open");
  memset(buf, 'A', BSIZE);
      f2:	40000613          	li	a2,1024
      f6:	04100593          	li	a1,65
      fa:	00002517          	auipc	a0,0x2
      fe:	f2650513          	addi	a0,a0,-218 # 2020 <buf>
     102:	00001097          	auipc	ra,0x1
     106:	ada080e7          	jalr	-1318(ra) # bdc <memset>
     10a:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
     10c:	00002997          	auipc	s3,0x2
     110:	f1498993          	addi	s3,s3,-236 # 2020 <buf>
     114:	40000613          	li	a2,1024
     118:	85ce                	mv	a1,s3
     11a:	854a                	mv	a0,s2
     11c:	00001097          	auipc	ra,0x1
     120:	cda080e7          	jalr	-806(ra) # df6 <write>
     124:	40000793          	li	a5,1024
     128:	02f51b63          	bne	a0,a5,15e <makefile+0x9a>
  for (i = 0; i < n + n/2; i++) {
     12c:	34fd                	addiw	s1,s1,-1
     12e:	f0fd                	bnez	s1,114 <makefile+0x50>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
     130:	854a                	mv	a0,s2
     132:	00001097          	auipc	ra,0x1
     136:	ccc080e7          	jalr	-820(ra) # dfe <close>
     13a:	57fd                	li	a5,-1
     13c:	02f50963          	beq	a0,a5,16e <makefile+0xaa>
    err("close");
}
     140:	70a2                	ld	ra,40(sp)
     142:	7402                	ld	s0,32(sp)
     144:	64e2                	ld	s1,24(sp)
     146:	6942                	ld	s2,16(sp)
     148:	69a2                	ld	s3,8(sp)
     14a:	6145                	addi	sp,sp,48
     14c:	8082                	ret
    err("open");
     14e:	00001517          	auipc	a0,0x1
     152:	24a50513          	addi	a0,a0,586 # 1398 <malloc+0x180>
     156:	00000097          	auipc	ra,0x0
     15a:	eaa080e7          	jalr	-342(ra) # 0 <err>
      err("write 0 makefile");
     15e:	00001517          	auipc	a0,0x1
     162:	24250513          	addi	a0,a0,578 # 13a0 <malloc+0x188>
     166:	00000097          	auipc	ra,0x0
     16a:	e9a080e7          	jalr	-358(ra) # 0 <err>
    err("close");
     16e:	00001517          	auipc	a0,0x1
     172:	24a50513          	addi	a0,a0,586 # 13b8 <malloc+0x1a0>
     176:	00000097          	auipc	ra,0x0
     17a:	e8a080e7          	jalr	-374(ra) # 0 <err>

000000000000017e <mmap_test>:

void
mmap_test(void)
{
     17e:	7139                	addi	sp,sp,-64
     180:	fc06                	sd	ra,56(sp)
     182:	f822                	sd	s0,48(sp)
     184:	f426                	sd	s1,40(sp)
     186:	f04a                	sd	s2,32(sp)
     188:	ec4e                	sd	s3,24(sp)
     18a:	e852                	sd	s4,16(sp)
     18c:	0080                	addi	s0,sp,64
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("mmap_test starting\n");
     18e:	00001517          	auipc	a0,0x1
     192:	23250513          	addi	a0,a0,562 # 13c0 <malloc+0x1a8>
     196:	00001097          	auipc	ra,0x1
     19a:	fca080e7          	jalr	-54(ra) # 1160 <printf>
  testname = "mmap_test";
     19e:	00001797          	auipc	a5,0x1
     1a2:	23a78793          	addi	a5,a5,570 # 13d8 <malloc+0x1c0>
     1a6:	00002717          	auipc	a4,0x2
     1aa:	e4f73d23          	sd	a5,-422(a4) # 2000 <testname>
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     1ae:	00001517          	auipc	a0,0x1
     1b2:	23a50513          	addi	a0,a0,570 # 13e8 <malloc+0x1d0>
     1b6:	00000097          	auipc	ra,0x0
     1ba:	f0e080e7          	jalr	-242(ra) # c4 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     1be:	4581                	li	a1,0
     1c0:	00001517          	auipc	a0,0x1
     1c4:	22850513          	addi	a0,a0,552 # 13e8 <malloc+0x1d0>
     1c8:	00001097          	auipc	ra,0x1
     1cc:	c4e080e7          	jalr	-946(ra) # e16 <open>
     1d0:	57fd                	li	a5,-1
     1d2:	56f50f63          	beq	a0,a5,750 <mmap_test+0x5d2>
     1d6:	892a                	mv	s2,a0
    err("open");

  printf("test mmap f\n");
     1d8:	00001517          	auipc	a0,0x1
     1dc:	22050513          	addi	a0,a0,544 # 13f8 <malloc+0x1e0>
     1e0:	00001097          	auipc	ra,0x1
     1e4:	f80080e7          	jalr	-128(ra) # 1160 <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1e8:	4781                	li	a5,0
     1ea:	874a                	mv	a4,s2
     1ec:	4689                	li	a3,2
     1ee:	4605                	li	a2,1
     1f0:	6589                	lui	a1,0x2
     1f2:	4501                	li	a0,0
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c82080e7          	jalr	-894(ra) # e76 <mmap>
     1fc:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     1fe:	57fd                	li	a5,-1
     200:	56f50063          	beq	a0,a5,760 <mmap_test+0x5e2>
    err("mmap (1)");
  _v1(p);
     204:	00000097          	auipc	ra,0x0
     208:	e3a080e7          	jalr	-454(ra) # 3e <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     20c:	6589                	lui	a1,0x2
     20e:	8526                	mv	a0,s1
     210:	00001097          	auipc	ra,0x1
     214:	c6e080e7          	jalr	-914(ra) # e7e <munmap>
     218:	57fd                	li	a5,-1
     21a:	54f50b63          	beq	a0,a5,770 <mmap_test+0x5f2>
    err("munmap (1)");

  printf("test mmap f: OK\n");
     21e:	00001517          	auipc	a0,0x1
     222:	20a50513          	addi	a0,a0,522 # 1428 <malloc+0x210>
     226:	00001097          	auipc	ra,0x1
     22a:	f3a080e7          	jalr	-198(ra) # 1160 <printf>
    
  printf("test mmap private\n");
     22e:	00001517          	auipc	a0,0x1
     232:	21250513          	addi	a0,a0,530 # 1440 <malloc+0x228>
     236:	00001097          	auipc	ra,0x1
     23a:	f2a080e7          	jalr	-214(ra) # 1160 <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     23e:	4781                	li	a5,0
     240:	874a                	mv	a4,s2
     242:	4689                	li	a3,2
     244:	460d                	li	a2,3
     246:	6589                	lui	a1,0x2
     248:	4501                	li	a0,0
     24a:	00001097          	auipc	ra,0x1
     24e:	c2c080e7          	jalr	-980(ra) # e76 <mmap>
     252:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     254:	57fd                	li	a5,-1
     256:	52f50563          	beq	a0,a5,780 <mmap_test+0x602>
    err("mmap (2)");
  if (close(fd) == -1)
     25a:	854a                	mv	a0,s2
     25c:	00001097          	auipc	ra,0x1
     260:	ba2080e7          	jalr	-1118(ra) # dfe <close>
     264:	57fd                	li	a5,-1
     266:	52f50563          	beq	a0,a5,790 <mmap_test+0x612>
    err("close");
  _v1(p);
     26a:	8526                	mv	a0,s1
     26c:	00000097          	auipc	ra,0x0
     270:	dd2080e7          	jalr	-558(ra) # 3e <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     274:	87a6                	mv	a5,s1
     276:	6709                	lui	a4,0x2
     278:	9726                	add	a4,a4,s1
    p[i] = 'Z';
     27a:	05a00693          	li	a3,90
     27e:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     282:	0785                	addi	a5,a5,1
     284:	fef71de3          	bne	a4,a5,27e <mmap_test+0x100>
  if (munmap(p, PGSIZE*2) == -1)
     288:	6589                	lui	a1,0x2
     28a:	8526                	mv	a0,s1
     28c:	00001097          	auipc	ra,0x1
     290:	bf2080e7          	jalr	-1038(ra) # e7e <munmap>
     294:	57fd                	li	a5,-1
     296:	50f50563          	beq	a0,a5,7a0 <mmap_test+0x622>
    err("munmap (2)");

  printf("test mmap private: OK\n");
     29a:	00001517          	auipc	a0,0x1
     29e:	1de50513          	addi	a0,a0,478 # 1478 <malloc+0x260>
     2a2:	00001097          	auipc	ra,0x1
     2a6:	ebe080e7          	jalr	-322(ra) # 1160 <printf>
    
  printf("test mmap read-only\n");
     2aa:	00001517          	auipc	a0,0x1
     2ae:	1e650513          	addi	a0,a0,486 # 1490 <malloc+0x278>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	eae080e7          	jalr	-338(ra) # 1160 <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     2ba:	4581                	li	a1,0
     2bc:	00001517          	auipc	a0,0x1
     2c0:	12c50513          	addi	a0,a0,300 # 13e8 <malloc+0x1d0>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b52080e7          	jalr	-1198(ra) # e16 <open>
     2cc:	84aa                	mv	s1,a0
     2ce:	57fd                	li	a5,-1
     2d0:	4ef50063          	beq	a0,a5,7b0 <mmap_test+0x632>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d4:	4781                	li	a5,0
     2d6:	872a                	mv	a4,a0
     2d8:	4685                	li	a3,1
     2da:	460d                	li	a2,3
     2dc:	658d                	lui	a1,0x3
     2de:	4501                	li	a0,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	b96080e7          	jalr	-1130(ra) # e76 <mmap>
  if (p != MAP_FAILED)
     2e8:	57fd                	li	a5,-1
     2ea:	4cf51b63          	bne	a0,a5,7c0 <mmap_test+0x642>
    err("mmap call should have failed");
  if (close(fd) == -1)
     2ee:	8526                	mv	a0,s1
     2f0:	00001097          	auipc	ra,0x1
     2f4:	b0e080e7          	jalr	-1266(ra) # dfe <close>
     2f8:	57fd                	li	a5,-1
     2fa:	4cf50b63          	beq	a0,a5,7d0 <mmap_test+0x652>
    err("close");

  printf("test mmap read-only: OK\n");
     2fe:	00001517          	auipc	a0,0x1
     302:	1ca50513          	addi	a0,a0,458 # 14c8 <malloc+0x2b0>
     306:	00001097          	auipc	ra,0x1
     30a:	e5a080e7          	jalr	-422(ra) # 1160 <printf>
    
  printf("test mmap read/write\n");
     30e:	00001517          	auipc	a0,0x1
     312:	1da50513          	addi	a0,a0,474 # 14e8 <malloc+0x2d0>
     316:	00001097          	auipc	ra,0x1
     31a:	e4a080e7          	jalr	-438(ra) # 1160 <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     31e:	4589                	li	a1,2
     320:	00001517          	auipc	a0,0x1
     324:	0c850513          	addi	a0,a0,200 # 13e8 <malloc+0x1d0>
     328:	00001097          	auipc	ra,0x1
     32c:	aee080e7          	jalr	-1298(ra) # e16 <open>
     330:	84aa                	mv	s1,a0
     332:	57fd                	li	a5,-1
     334:	4af50663          	beq	a0,a5,7e0 <mmap_test+0x662>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     338:	4781                	li	a5,0
     33a:	872a                	mv	a4,a0
     33c:	4685                	li	a3,1
     33e:	460d                	li	a2,3
     340:	658d                	lui	a1,0x3
     342:	4501                	li	a0,0
     344:	00001097          	auipc	ra,0x1
     348:	b32080e7          	jalr	-1230(ra) # e76 <mmap>
     34c:	89aa                	mv	s3,a0
  if (p == MAP_FAILED)
     34e:	57fd                	li	a5,-1
     350:	4af50063          	beq	a0,a5,7f0 <mmap_test+0x672>
    err("mmap (3)");
  if (close(fd) == -1)
     354:	8526                	mv	a0,s1
     356:	00001097          	auipc	ra,0x1
     35a:	aa8080e7          	jalr	-1368(ra) # dfe <close>
     35e:	57fd                	li	a5,-1
     360:	4af50063          	beq	a0,a5,800 <mmap_test+0x682>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
     364:	854e                	mv	a0,s3
     366:	00000097          	auipc	ra,0x0
     36a:	cd8080e7          	jalr	-808(ra) # 3e <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
     36e:	87ce                	mv	a5,s3
     370:	6709                	lui	a4,0x2
     372:	974e                	add	a4,a4,s3
    p[i] = 'Z';
     374:	05a00693          	li	a3,90
     378:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     37c:	0785                	addi	a5,a5,1
     37e:	fee79de3          	bne	a5,a4,378 <mmap_test+0x1fa>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     382:	6589                	lui	a1,0x2
     384:	854e                	mv	a0,s3
     386:	00001097          	auipc	ra,0x1
     38a:	af8080e7          	jalr	-1288(ra) # e7e <munmap>
     38e:	57fd                	li	a5,-1
     390:	48f50063          	beq	a0,a5,810 <mmap_test+0x692>
    err("munmap (3)");
  
  printf("test mmap read/write: OK\n");
     394:	00001517          	auipc	a0,0x1
     398:	18c50513          	addi	a0,a0,396 # 1520 <malloc+0x308>
     39c:	00001097          	auipc	ra,0x1
     3a0:	dc4080e7          	jalr	-572(ra) # 1160 <printf>
  
  printf("test mmap dirty\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	19c50513          	addi	a0,a0,412 # 1540 <malloc+0x328>
     3ac:	00001097          	auipc	ra,0x1
     3b0:	db4080e7          	jalr	-588(ra) # 1160 <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
     3b4:	4589                	li	a1,2
     3b6:	00001517          	auipc	a0,0x1
     3ba:	03250513          	addi	a0,a0,50 # 13e8 <malloc+0x1d0>
     3be:	00001097          	auipc	ra,0x1
     3c2:	a58080e7          	jalr	-1448(ra) # e16 <open>
     3c6:	892a                	mv	s2,a0
     3c8:	57fd                	li	a5,-1
     3ca:	6489                	lui	s1,0x2
     3cc:	80048493          	addi	s1,s1,-2048 # 1800 <malloc+0x5e8>
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read (1)");
    if (b != 'Z')
     3d0:	05a00a13          	li	s4,90
  if ((fd = open(f, O_RDWR)) == -1)
     3d4:	44f50663          	beq	a0,a5,820 <mmap_test+0x6a2>
    if (read(fd, &b, 1) != 1)
     3d8:	4605                	li	a2,1
     3da:	fcf40593          	addi	a1,s0,-49
     3de:	854a                	mv	a0,s2
     3e0:	00001097          	auipc	ra,0x1
     3e4:	a0e080e7          	jalr	-1522(ra) # dee <read>
     3e8:	4785                	li	a5,1
     3ea:	44f51363          	bne	a0,a5,830 <mmap_test+0x6b2>
    if (b != 'Z')
     3ee:	fcf44783          	lbu	a5,-49(s0)
     3f2:	45479763          	bne	a5,s4,840 <mmap_test+0x6c2>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
     3f6:	34fd                	addiw	s1,s1,-1
     3f8:	f0e5                	bnez	s1,3d8 <mmap_test+0x25a>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
     3fa:	854a                	mv	a0,s2
     3fc:	00001097          	auipc	ra,0x1
     400:	a02080e7          	jalr	-1534(ra) # dfe <close>
     404:	57fd                	li	a5,-1
     406:	44f50563          	beq	a0,a5,850 <mmap_test+0x6d2>
    err("close");

  printf("test mmap dirty: OK\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	18650513          	addi	a0,a0,390 # 1590 <malloc+0x378>
     412:	00001097          	auipc	ra,0x1
     416:	d4e080e7          	jalr	-690(ra) # 1160 <printf>

  printf("test not-mapped unmap\n");
     41a:	00001517          	auipc	a0,0x1
     41e:	18e50513          	addi	a0,a0,398 # 15a8 <malloc+0x390>
     422:	00001097          	auipc	ra,0x1
     426:	d3e080e7          	jalr	-706(ra) # 1160 <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     42a:	6585                	lui	a1,0x1
     42c:	6509                	lui	a0,0x2
     42e:	954e                	add	a0,a0,s3
     430:	00001097          	auipc	ra,0x1
     434:	a4e080e7          	jalr	-1458(ra) # e7e <munmap>
     438:	57fd                	li	a5,-1
     43a:	42f50363          	beq	a0,a5,860 <mmap_test+0x6e2>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     43e:	00001517          	auipc	a0,0x1
     442:	19250513          	addi	a0,a0,402 # 15d0 <malloc+0x3b8>
     446:	00001097          	auipc	ra,0x1
     44a:	d1a080e7          	jalr	-742(ra) # 1160 <printf>
    
  printf("test mmap two files\n");
     44e:	00001517          	auipc	a0,0x1
     452:	1a250513          	addi	a0,a0,418 # 15f0 <malloc+0x3d8>
     456:	00001097          	auipc	ra,0x1
     45a:	d0a080e7          	jalr	-758(ra) # 1160 <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     45e:	20200593          	li	a1,514
     462:	00001517          	auipc	a0,0x1
     466:	1a650513          	addi	a0,a0,422 # 1608 <malloc+0x3f0>
     46a:	00001097          	auipc	ra,0x1
     46e:	9ac080e7          	jalr	-1620(ra) # e16 <open>
     472:	84aa                	mv	s1,a0
     474:	3e054e63          	bltz	a0,870 <mmap_test+0x6f2>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
     478:	4615                	li	a2,5
     47a:	00001597          	auipc	a1,0x1
     47e:	1a658593          	addi	a1,a1,422 # 1620 <malloc+0x408>
     482:	00001097          	auipc	ra,0x1
     486:	974080e7          	jalr	-1676(ra) # df6 <write>
     48a:	4795                	li	a5,5
     48c:	3ef51a63          	bne	a0,a5,880 <mmap_test+0x702>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     490:	4781                	li	a5,0
     492:	8726                	mv	a4,s1
     494:	4689                	li	a3,2
     496:	4605                	li	a2,1
     498:	6585                	lui	a1,0x1
     49a:	4501                	li	a0,0
     49c:	00001097          	auipc	ra,0x1
     4a0:	9da080e7          	jalr	-1574(ra) # e76 <mmap>
     4a4:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     4a6:	57fd                	li	a5,-1
     4a8:	3ef50463          	beq	a0,a5,890 <mmap_test+0x712>
    err("mmap mmap1");
  close(fd1);
     4ac:	8526                	mv	a0,s1
     4ae:	00001097          	auipc	ra,0x1
     4b2:	950080e7          	jalr	-1712(ra) # dfe <close>
  unlink("mmap1");
     4b6:	00001517          	auipc	a0,0x1
     4ba:	15250513          	addi	a0,a0,338 # 1608 <malloc+0x3f0>
     4be:	00001097          	auipc	ra,0x1
     4c2:	968080e7          	jalr	-1688(ra) # e26 <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     4c6:	20200593          	li	a1,514
     4ca:	00001517          	auipc	a0,0x1
     4ce:	17e50513          	addi	a0,a0,382 # 1648 <malloc+0x430>
     4d2:	00001097          	auipc	ra,0x1
     4d6:	944080e7          	jalr	-1724(ra) # e16 <open>
     4da:	892a                	mv	s2,a0
     4dc:	3c054263          	bltz	a0,8a0 <mmap_test+0x722>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
     4e0:	4615                	li	a2,5
     4e2:	00001597          	auipc	a1,0x1
     4e6:	17e58593          	addi	a1,a1,382 # 1660 <malloc+0x448>
     4ea:	00001097          	auipc	ra,0x1
     4ee:	90c080e7          	jalr	-1780(ra) # df6 <write>
     4f2:	4795                	li	a5,5
     4f4:	3af51e63          	bne	a0,a5,8b0 <mmap_test+0x732>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4f8:	4781                	li	a5,0
     4fa:	874a                	mv	a4,s2
     4fc:	4689                	li	a3,2
     4fe:	4605                	li	a2,1
     500:	6585                	lui	a1,0x1
     502:	4501                	li	a0,0
     504:	00001097          	auipc	ra,0x1
     508:	972080e7          	jalr	-1678(ra) # e76 <mmap>
     50c:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     50e:	57fd                	li	a5,-1
     510:	3af50863          	beq	a0,a5,8c0 <mmap_test+0x742>
    err("mmap mmap2");
  close(fd2);
     514:	854a                	mv	a0,s2
     516:	00001097          	auipc	ra,0x1
     51a:	8e8080e7          	jalr	-1816(ra) # dfe <close>
  unlink("mmap2");
     51e:	00001517          	auipc	a0,0x1
     522:	12a50513          	addi	a0,a0,298 # 1648 <malloc+0x430>
     526:	00001097          	auipc	ra,0x1
     52a:	900080e7          	jalr	-1792(ra) # e26 <unlink>

  if(memcmp(p1, "12345", 5) != 0)
     52e:	4615                	li	a2,5
     530:	00001597          	auipc	a1,0x1
     534:	0f058593          	addi	a1,a1,240 # 1620 <malloc+0x408>
     538:	854e                	mv	a0,s3
     53a:	00001097          	auipc	ra,0x1
     53e:	842080e7          	jalr	-1982(ra) # d7c <memcmp>
     542:	38051763          	bnez	a0,8d0 <mmap_test+0x752>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     546:	4615                	li	a2,5
     548:	00001597          	auipc	a1,0x1
     54c:	11858593          	addi	a1,a1,280 # 1660 <malloc+0x448>
     550:	8526                	mv	a0,s1
     552:	00001097          	auipc	ra,0x1
     556:	82a080e7          	jalr	-2006(ra) # d7c <memcmp>
     55a:	38051363          	bnez	a0,8e0 <mmap_test+0x762>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
     55e:	6585                	lui	a1,0x1
     560:	854e                	mv	a0,s3
     562:	00001097          	auipc	ra,0x1
     566:	91c080e7          	jalr	-1764(ra) # e7e <munmap>
  if(memcmp(p2, "67890", 5) != 0)
     56a:	4615                	li	a2,5
     56c:	00001597          	auipc	a1,0x1
     570:	0f458593          	addi	a1,a1,244 # 1660 <malloc+0x448>
     574:	8526                	mv	a0,s1
     576:	00001097          	auipc	ra,0x1
     57a:	806080e7          	jalr	-2042(ra) # d7c <memcmp>
     57e:	36051963          	bnez	a0,8f0 <mmap_test+0x772>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
     582:	6585                	lui	a1,0x1
     584:	8526                	mv	a0,s1
     586:	00001097          	auipc	ra,0x1
     58a:	8f8080e7          	jalr	-1800(ra) # e7e <munmap>
  
  printf("test mmap two files: OK\n");
     58e:	00001517          	auipc	a0,0x1
     592:	13250513          	addi	a0,a0,306 # 16c0 <malloc+0x4a8>
     596:	00001097          	auipc	ra,0x1
     59a:	bca080e7          	jalr	-1078(ra) # 1160 <printf>

  //
  // Check offset argument to mmap.
  //
  printf("test mmap offset\n");
     59e:	00001517          	auipc	a0,0x1
     5a2:	14250513          	addi	a0,a0,322 # 16e0 <malloc+0x4c8>
     5a6:	00001097          	auipc	ra,0x1
     5aa:	bba080e7          	jalr	-1094(ra) # 1160 <printf>

  // Fill the buffer with 'A' for the first page and 'B' for the second page
  for (i = 0; i < PGSIZE; i++) {
     5ae:	00002797          	auipc	a5,0x2
     5b2:	e7278793          	addi	a5,a5,-398 # 2420 <buff>
     5b6:	00003517          	auipc	a0,0x3
     5ba:	e6a50513          	addi	a0,a0,-406 # 3420 <buff+0x1000>
      buff[i] = 'A';
     5be:	04100593          	li	a1,65
      buff[i + PGSIZE] = 'B';
     5c2:	6605                	lui	a2,0x1
     5c4:	04200693          	li	a3,66
      buff[i] = 'A';
     5c8:	00b78023          	sb	a1,0(a5)
      buff[i + PGSIZE] = 'B';
     5cc:	00c78733          	add	a4,a5,a2
     5d0:	00d70023          	sb	a3,0(a4) # 2000 <testname>
  for (i = 0; i < PGSIZE; i++) {
     5d4:	0785                	addi	a5,a5,1
     5d6:	fea799e3          	bne	a5,a0,5c8 <mmap_test+0x44a>
  }

  // Create and open the file
  int fd3;
  if((fd3 = open("mmap3", O_RDWR | O_CREATE)) < 0)
     5da:	20200593          	li	a1,514
     5de:	00001517          	auipc	a0,0x1
     5e2:	11a50513          	addi	a0,a0,282 # 16f8 <malloc+0x4e0>
     5e6:	00001097          	auipc	ra,0x1
     5ea:	830080e7          	jalr	-2000(ra) # e16 <open>
     5ee:	84aa                	mv	s1,a0
     5f0:	30054863          	bltz	a0,900 <mmap_test+0x782>
      err("open mmap3");

  // Write the buffer to the file
  if (write(fd3, buff, sizeof(buff)) != sizeof(buff)) {
     5f4:	6609                	lui	a2,0x2
     5f6:	00002597          	auipc	a1,0x2
     5fa:	e2a58593          	addi	a1,a1,-470 # 2420 <buff>
     5fe:	00000097          	auipc	ra,0x0
     602:	7f8080e7          	jalr	2040(ra) # df6 <write>
     606:	6789                	lui	a5,0x2
     608:	30f51463          	bne	a0,a5,910 <mmap_test+0x792>
      err("write mmap3");
  }

  p = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd3, PGSIZE);
     60c:	6785                	lui	a5,0x1
     60e:	8726                	mv	a4,s1
     610:	4689                	li	a3,2
     612:	4605                	li	a2,1
     614:	6585                	lui	a1,0x1
     616:	4501                	li	a0,0
     618:	00001097          	auipc	ra,0x1
     61c:	85e080e7          	jalr	-1954(ra) # e76 <mmap>
  if(p == MAP_FAILED)
     620:	57fd                	li	a5,-1
     622:	2ef50f63          	beq	a0,a5,920 <mmap_test+0x7a2>
      err("mmap offset");
  if(*p != 'B')
     626:	00054703          	lbu	a4,0(a0)
     62a:	04200793          	li	a5,66
     62e:	30f71163          	bne	a4,a5,930 <mmap_test+0x7b2>
      err("mmap offset mismatch");
  munmap(p, PGSIZE);
     632:	6585                	lui	a1,0x1
     634:	00001097          	auipc	ra,0x1
     638:	84a080e7          	jalr	-1974(ra) # e7e <munmap>
  close(fd3);
     63c:	8526                	mv	a0,s1
     63e:	00000097          	auipc	ra,0x0
     642:	7c0080e7          	jalr	1984(ra) # dfe <close>
  unlink("mmap3");
     646:	00001517          	auipc	a0,0x1
     64a:	0b250513          	addi	a0,a0,178 # 16f8 <malloc+0x4e0>
     64e:	00000097          	auipc	ra,0x0
     652:	7d8080e7          	jalr	2008(ra) # e26 <unlink>
  printf("test mmap offset: OK\n");
     656:	00001517          	auipc	a0,0x1
     65a:	0f250513          	addi	a0,a0,242 # 1748 <malloc+0x530>
     65e:	00001097          	auipc	ra,0x1
     662:	b02080e7          	jalr	-1278(ra) # 1160 <printf>

  // Check that the half page file is mapped correctly
  printf("test mmap half page\n");
     666:	00001517          	auipc	a0,0x1
     66a:	0fa50513          	addi	a0,a0,250 # 1760 <malloc+0x548>
     66e:	00001097          	auipc	ra,0x1
     672:	af2080e7          	jalr	-1294(ra) # 1160 <printf>
  int fd4;
  if((fd4 = open("mmap4", O_RDWR | O_CREATE)) < 0)
     676:	20200593          	li	a1,514
     67a:	00001517          	auipc	a0,0x1
     67e:	0fe50513          	addi	a0,a0,254 # 1778 <malloc+0x560>
     682:	00000097          	auipc	ra,0x0
     686:	794080e7          	jalr	1940(ra) # e16 <open>
     68a:	84aa                	mv	s1,a0
     68c:	2a054a63          	bltz	a0,940 <mmap_test+0x7c2>
      err("open mmap4");
  if(write(fd4, buff, PGSIZE) != PGSIZE)
     690:	6605                	lui	a2,0x1
     692:	00002597          	auipc	a1,0x2
     696:	d8e58593          	addi	a1,a1,-626 # 2420 <buff>
     69a:	00000097          	auipc	ra,0x0
     69e:	75c080e7          	jalr	1884(ra) # df6 <write>
     6a2:	6785                	lui	a5,0x1
     6a4:	2af51663          	bne	a0,a5,950 <mmap_test+0x7d2>
      err("write mmap4");

  char *p4 = mmap(0, PGSIZE / 2, PROT_READ, MAP_PRIVATE, fd4, 0);
     6a8:	4781                	li	a5,0
     6aa:	8726                	mv	a4,s1
     6ac:	4689                	li	a3,2
     6ae:	4605                	li	a2,1
     6b0:	6585                	lui	a1,0x1
     6b2:	80058593          	addi	a1,a1,-2048 # 800 <mmap_test+0x682>
     6b6:	4501                	li	a0,0
     6b8:	00000097          	auipc	ra,0x0
     6bc:	7be080e7          	jalr	1982(ra) # e76 <mmap>
     6c0:	892a                	mv	s2,a0
  if(p4 == MAP_FAILED)
     6c2:	57fd                	li	a5,-1
     6c4:	28f50e63          	beq	a0,a5,960 <mmap_test+0x7e2>
      err("mmap half page");

  char *p5 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd4, 0);
     6c8:	4781                	li	a5,0
     6ca:	8726                	mv	a4,s1
     6cc:	4689                	li	a3,2
     6ce:	4605                	li	a2,1
     6d0:	6585                	lui	a1,0x1
     6d2:	4501                	li	a0,0
     6d4:	00000097          	auipc	ra,0x0
     6d8:	7a2080e7          	jalr	1954(ra) # e76 <mmap>
  if(p5 == MAP_FAILED)
     6dc:	57fd                	li	a5,-1
     6de:	28f50963          	beq	a0,a5,970 <mmap_test+0x7f2>
      err("mmap page");

  if((p5-p4)%PGSIZE)
     6e2:	412507b3          	sub	a5,a0,s2
     6e6:	17d2                	slli	a5,a5,0x34
     6e8:	28079c63          	bnez	a5,980 <mmap_test+0x802>
      err("page alignment mismatch");

  munmap(p5, PGSIZE);
     6ec:	6585                	lui	a1,0x1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	790080e7          	jalr	1936(ra) # e7e <munmap>
  munmap(p4, PGSIZE / 2);
     6f6:	6585                	lui	a1,0x1
     6f8:	80058593          	addi	a1,a1,-2048 # 800 <mmap_test+0x682>
     6fc:	854a                	mv	a0,s2
     6fe:	00000097          	auipc	ra,0x0
     702:	780080e7          	jalr	1920(ra) # e7e <munmap>
  close(fd4);
     706:	8526                	mv	a0,s1
     708:	00000097          	auipc	ra,0x0
     70c:	6f6080e7          	jalr	1782(ra) # dfe <close>
  unlink("mmap4");
     710:	00001517          	auipc	a0,0x1
     714:	06850513          	addi	a0,a0,104 # 1778 <malloc+0x560>
     718:	00000097          	auipc	ra,0x0
     71c:	70e080e7          	jalr	1806(ra) # e26 <unlink>
  printf("test mmap half page: OK\n");
     720:	00001517          	auipc	a0,0x1
     724:	0b850513          	addi	a0,a0,184 # 17d8 <malloc+0x5c0>
     728:	00001097          	auipc	ra,0x1
     72c:	a38080e7          	jalr	-1480(ra) # 1160 <printf>
  
  printf("mmap_test: ALL OK\n");
     730:	00001517          	auipc	a0,0x1
     734:	0c850513          	addi	a0,a0,200 # 17f8 <malloc+0x5e0>
     738:	00001097          	auipc	ra,0x1
     73c:	a28080e7          	jalr	-1496(ra) # 1160 <printf>
}
     740:	70e2                	ld	ra,56(sp)
     742:	7442                	ld	s0,48(sp)
     744:	74a2                	ld	s1,40(sp)
     746:	7902                	ld	s2,32(sp)
     748:	69e2                	ld	s3,24(sp)
     74a:	6a42                	ld	s4,16(sp)
     74c:	6121                	addi	sp,sp,64
     74e:	8082                	ret
    err("open");
     750:	00001517          	auipc	a0,0x1
     754:	c4850513          	addi	a0,a0,-952 # 1398 <malloc+0x180>
     758:	00000097          	auipc	ra,0x0
     75c:	8a8080e7          	jalr	-1880(ra) # 0 <err>
    err("mmap (1)");
     760:	00001517          	auipc	a0,0x1
     764:	ca850513          	addi	a0,a0,-856 # 1408 <malloc+0x1f0>
     768:	00000097          	auipc	ra,0x0
     76c:	898080e7          	jalr	-1896(ra) # 0 <err>
    err("munmap (1)");
     770:	00001517          	auipc	a0,0x1
     774:	ca850513          	addi	a0,a0,-856 # 1418 <malloc+0x200>
     778:	00000097          	auipc	ra,0x0
     77c:	888080e7          	jalr	-1912(ra) # 0 <err>
    err("mmap (2)");
     780:	00001517          	auipc	a0,0x1
     784:	cd850513          	addi	a0,a0,-808 # 1458 <malloc+0x240>
     788:	00000097          	auipc	ra,0x0
     78c:	878080e7          	jalr	-1928(ra) # 0 <err>
    err("close");
     790:	00001517          	auipc	a0,0x1
     794:	c2850513          	addi	a0,a0,-984 # 13b8 <malloc+0x1a0>
     798:	00000097          	auipc	ra,0x0
     79c:	868080e7          	jalr	-1944(ra) # 0 <err>
    err("munmap (2)");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	cc850513          	addi	a0,a0,-824 # 1468 <malloc+0x250>
     7a8:	00000097          	auipc	ra,0x0
     7ac:	858080e7          	jalr	-1960(ra) # 0 <err>
    err("open");
     7b0:	00001517          	auipc	a0,0x1
     7b4:	be850513          	addi	a0,a0,-1048 # 1398 <malloc+0x180>
     7b8:	00000097          	auipc	ra,0x0
     7bc:	848080e7          	jalr	-1976(ra) # 0 <err>
    err("mmap call should have failed");
     7c0:	00001517          	auipc	a0,0x1
     7c4:	ce850513          	addi	a0,a0,-792 # 14a8 <malloc+0x290>
     7c8:	00000097          	auipc	ra,0x0
     7cc:	838080e7          	jalr	-1992(ra) # 0 <err>
    err("close");
     7d0:	00001517          	auipc	a0,0x1
     7d4:	be850513          	addi	a0,a0,-1048 # 13b8 <malloc+0x1a0>
     7d8:	00000097          	auipc	ra,0x0
     7dc:	828080e7          	jalr	-2008(ra) # 0 <err>
    err("open");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	bb850513          	addi	a0,a0,-1096 # 1398 <malloc+0x180>
     7e8:	00000097          	auipc	ra,0x0
     7ec:	818080e7          	jalr	-2024(ra) # 0 <err>
    err("mmap (3)");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	d1050513          	addi	a0,a0,-752 # 1500 <malloc+0x2e8>
     7f8:	00000097          	auipc	ra,0x0
     7fc:	808080e7          	jalr	-2040(ra) # 0 <err>
    err("close");
     800:	00001517          	auipc	a0,0x1
     804:	bb850513          	addi	a0,a0,-1096 # 13b8 <malloc+0x1a0>
     808:	fffff097          	auipc	ra,0xfffff
     80c:	7f8080e7          	jalr	2040(ra) # 0 <err>
    err("munmap (3)");
     810:	00001517          	auipc	a0,0x1
     814:	d0050513          	addi	a0,a0,-768 # 1510 <malloc+0x2f8>
     818:	fffff097          	auipc	ra,0xfffff
     81c:	7e8080e7          	jalr	2024(ra) # 0 <err>
    err("open");
     820:	00001517          	auipc	a0,0x1
     824:	b7850513          	addi	a0,a0,-1160 # 1398 <malloc+0x180>
     828:	fffff097          	auipc	ra,0xfffff
     82c:	7d8080e7          	jalr	2008(ra) # 0 <err>
      err("read (1)");
     830:	00001517          	auipc	a0,0x1
     834:	d2850513          	addi	a0,a0,-728 # 1558 <malloc+0x340>
     838:	fffff097          	auipc	ra,0xfffff
     83c:	7c8080e7          	jalr	1992(ra) # 0 <err>
      err("file does not contain modifications");
     840:	00001517          	auipc	a0,0x1
     844:	d2850513          	addi	a0,a0,-728 # 1568 <malloc+0x350>
     848:	fffff097          	auipc	ra,0xfffff
     84c:	7b8080e7          	jalr	1976(ra) # 0 <err>
    err("close");
     850:	00001517          	auipc	a0,0x1
     854:	b6850513          	addi	a0,a0,-1176 # 13b8 <malloc+0x1a0>
     858:	fffff097          	auipc	ra,0xfffff
     85c:	7a8080e7          	jalr	1960(ra) # 0 <err>
    err("munmap (4)");
     860:	00001517          	auipc	a0,0x1
     864:	d6050513          	addi	a0,a0,-672 # 15c0 <malloc+0x3a8>
     868:	fffff097          	auipc	ra,0xfffff
     86c:	798080e7          	jalr	1944(ra) # 0 <err>
    err("open mmap1");
     870:	00001517          	auipc	a0,0x1
     874:	da050513          	addi	a0,a0,-608 # 1610 <malloc+0x3f8>
     878:	fffff097          	auipc	ra,0xfffff
     87c:	788080e7          	jalr	1928(ra) # 0 <err>
    err("write mmap1");
     880:	00001517          	auipc	a0,0x1
     884:	da850513          	addi	a0,a0,-600 # 1628 <malloc+0x410>
     888:	fffff097          	auipc	ra,0xfffff
     88c:	778080e7          	jalr	1912(ra) # 0 <err>
    err("mmap mmap1");
     890:	00001517          	auipc	a0,0x1
     894:	da850513          	addi	a0,a0,-600 # 1638 <malloc+0x420>
     898:	fffff097          	auipc	ra,0xfffff
     89c:	768080e7          	jalr	1896(ra) # 0 <err>
    err("open mmap2");
     8a0:	00001517          	auipc	a0,0x1
     8a4:	db050513          	addi	a0,a0,-592 # 1650 <malloc+0x438>
     8a8:	fffff097          	auipc	ra,0xfffff
     8ac:	758080e7          	jalr	1880(ra) # 0 <err>
    err("write mmap2");
     8b0:	00001517          	auipc	a0,0x1
     8b4:	db850513          	addi	a0,a0,-584 # 1668 <malloc+0x450>
     8b8:	fffff097          	auipc	ra,0xfffff
     8bc:	748080e7          	jalr	1864(ra) # 0 <err>
    err("mmap mmap2");
     8c0:	00001517          	auipc	a0,0x1
     8c4:	db850513          	addi	a0,a0,-584 # 1678 <malloc+0x460>
     8c8:	fffff097          	auipc	ra,0xfffff
     8cc:	738080e7          	jalr	1848(ra) # 0 <err>
    err("mmap1 mismatch");
     8d0:	00001517          	auipc	a0,0x1
     8d4:	db850513          	addi	a0,a0,-584 # 1688 <malloc+0x470>
     8d8:	fffff097          	auipc	ra,0xfffff
     8dc:	728080e7          	jalr	1832(ra) # 0 <err>
    err("mmap2 mismatch");
     8e0:	00001517          	auipc	a0,0x1
     8e4:	db850513          	addi	a0,a0,-584 # 1698 <malloc+0x480>
     8e8:	fffff097          	auipc	ra,0xfffff
     8ec:	718080e7          	jalr	1816(ra) # 0 <err>
    err("mmap2 mismatch (2)");
     8f0:	00001517          	auipc	a0,0x1
     8f4:	db850513          	addi	a0,a0,-584 # 16a8 <malloc+0x490>
     8f8:	fffff097          	auipc	ra,0xfffff
     8fc:	708080e7          	jalr	1800(ra) # 0 <err>
      err("open mmap3");
     900:	00001517          	auipc	a0,0x1
     904:	e0050513          	addi	a0,a0,-512 # 1700 <malloc+0x4e8>
     908:	fffff097          	auipc	ra,0xfffff
     90c:	6f8080e7          	jalr	1784(ra) # 0 <err>
      err("write mmap3");
     910:	00001517          	auipc	a0,0x1
     914:	e0050513          	addi	a0,a0,-512 # 1710 <malloc+0x4f8>
     918:	fffff097          	auipc	ra,0xfffff
     91c:	6e8080e7          	jalr	1768(ra) # 0 <err>
      err("mmap offset");
     920:	00001517          	auipc	a0,0x1
     924:	e0050513          	addi	a0,a0,-512 # 1720 <malloc+0x508>
     928:	fffff097          	auipc	ra,0xfffff
     92c:	6d8080e7          	jalr	1752(ra) # 0 <err>
      err("mmap offset mismatch");
     930:	00001517          	auipc	a0,0x1
     934:	e0050513          	addi	a0,a0,-512 # 1730 <malloc+0x518>
     938:	fffff097          	auipc	ra,0xfffff
     93c:	6c8080e7          	jalr	1736(ra) # 0 <err>
      err("open mmap4");
     940:	00001517          	auipc	a0,0x1
     944:	e4050513          	addi	a0,a0,-448 # 1780 <malloc+0x568>
     948:	fffff097          	auipc	ra,0xfffff
     94c:	6b8080e7          	jalr	1720(ra) # 0 <err>
      err("write mmap4");
     950:	00001517          	auipc	a0,0x1
     954:	e4050513          	addi	a0,a0,-448 # 1790 <malloc+0x578>
     958:	fffff097          	auipc	ra,0xfffff
     95c:	6a8080e7          	jalr	1704(ra) # 0 <err>
      err("mmap half page");
     960:	00001517          	auipc	a0,0x1
     964:	e4050513          	addi	a0,a0,-448 # 17a0 <malloc+0x588>
     968:	fffff097          	auipc	ra,0xfffff
     96c:	698080e7          	jalr	1688(ra) # 0 <err>
      err("mmap page");
     970:	00001517          	auipc	a0,0x1
     974:	e4050513          	addi	a0,a0,-448 # 17b0 <malloc+0x598>
     978:	fffff097          	auipc	ra,0xfffff
     97c:	688080e7          	jalr	1672(ra) # 0 <err>
      err("page alignment mismatch");
     980:	00001517          	auipc	a0,0x1
     984:	e4050513          	addi	a0,a0,-448 # 17c0 <malloc+0x5a8>
     988:	fffff097          	auipc	ra,0xfffff
     98c:	678080e7          	jalr	1656(ra) # 0 <err>

0000000000000990 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     990:	7179                	addi	sp,sp,-48
     992:	f406                	sd	ra,40(sp)
     994:	f022                	sd	s0,32(sp)
     996:	ec26                	sd	s1,24(sp)
     998:	e84a                	sd	s2,16(sp)
     99a:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
     99c:	00001517          	auipc	a0,0x1
     9a0:	e7450513          	addi	a0,a0,-396 # 1810 <malloc+0x5f8>
     9a4:	00000097          	auipc	ra,0x0
     9a8:	7bc080e7          	jalr	1980(ra) # 1160 <printf>
  testname = "fork_test";
     9ac:	00001797          	auipc	a5,0x1
     9b0:	e7c78793          	addi	a5,a5,-388 # 1828 <malloc+0x610>
     9b4:	00001717          	auipc	a4,0x1
     9b8:	64f73623          	sd	a5,1612(a4) # 2000 <testname>
  
  // mmap the file twice.
  makefile(f);
     9bc:	00001517          	auipc	a0,0x1
     9c0:	a2c50513          	addi	a0,a0,-1492 # 13e8 <malloc+0x1d0>
     9c4:	fffff097          	auipc	ra,0xfffff
     9c8:	700080e7          	jalr	1792(ra) # c4 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     9cc:	4581                	li	a1,0
     9ce:	00001517          	auipc	a0,0x1
     9d2:	a1a50513          	addi	a0,a0,-1510 # 13e8 <malloc+0x1d0>
     9d6:	00000097          	auipc	ra,0x0
     9da:	440080e7          	jalr	1088(ra) # e16 <open>
     9de:	57fd                	li	a5,-1
     9e0:	0af50a63          	beq	a0,a5,a94 <fork_test+0x104>
     9e4:	84aa                	mv	s1,a0
    err("open");
  unlink(f);
     9e6:	00001517          	auipc	a0,0x1
     9ea:	a0250513          	addi	a0,a0,-1534 # 13e8 <malloc+0x1d0>
     9ee:	00000097          	auipc	ra,0x0
     9f2:	438080e7          	jalr	1080(ra) # e26 <unlink>
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     9f6:	4781                	li	a5,0
     9f8:	8726                	mv	a4,s1
     9fa:	4685                	li	a3,1
     9fc:	4605                	li	a2,1
     9fe:	6589                	lui	a1,0x2
     a00:	4501                	li	a0,0
     a02:	00000097          	auipc	ra,0x0
     a06:	474080e7          	jalr	1140(ra) # e76 <mmap>
     a0a:	892a                	mv	s2,a0
  if (p1 == MAP_FAILED)
     a0c:	57fd                	li	a5,-1
     a0e:	08f50b63          	beq	a0,a5,aa4 <fork_test+0x114>
    err("mmap (4)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     a12:	4781                	li	a5,0
     a14:	8726                	mv	a4,s1
     a16:	4685                	li	a3,1
     a18:	4605                	li	a2,1
     a1a:	6589                	lui	a1,0x2
     a1c:	4501                	li	a0,0
     a1e:	00000097          	auipc	ra,0x0
     a22:	458080e7          	jalr	1112(ra) # e76 <mmap>
     a26:	84aa                	mv	s1,a0
  if (p2 == MAP_FAILED)
     a28:	57fd                	li	a5,-1
     a2a:	08f50563          	beq	a0,a5,ab4 <fork_test+0x124>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     a2e:	6785                	lui	a5,0x1
     a30:	97ca                	add	a5,a5,s2
     a32:	0007c703          	lbu	a4,0(a5) # 1000 <vprintf+0xac>
     a36:	04100793          	li	a5,65
     a3a:	08f71563          	bne	a4,a5,ac4 <fork_test+0x134>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     a3e:	00000097          	auipc	ra,0x0
     a42:	390080e7          	jalr	912(ra) # dce <fork>
     a46:	08054763          	bltz	a0,ad4 <fork_test+0x144>
    err("fork");
  if (pid == 0) {
     a4a:	cd49                	beqz	a0,ae4 <fork_test+0x154>
    _v1(p1);
    munmap(p1, PGSIZE); // just the first page
    exit(0); // tell the parent that the mapping looks OK.
  }

  int status = -1;
     a4c:	57fd                	li	a5,-1
     a4e:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     a52:	fdc40513          	addi	a0,s0,-36
     a56:	00000097          	auipc	ra,0x0
     a5a:	388080e7          	jalr	904(ra) # dde <wait>

  if(status != 0){
     a5e:	fdc42783          	lw	a5,-36(s0)
     a62:	e3cd                	bnez	a5,b04 <fork_test+0x174>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     a64:	854a                	mv	a0,s2
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	5d8080e7          	jalr	1496(ra) # 3e <_v1>
  _v1(p2);
     a6e:	8526                	mv	a0,s1
     a70:	fffff097          	auipc	ra,0xfffff
     a74:	5ce080e7          	jalr	1486(ra) # 3e <_v1>

  printf("fork_test OK\n");
     a78:	00001517          	auipc	a0,0x1
     a7c:	e1850513          	addi	a0,a0,-488 # 1890 <malloc+0x678>
     a80:	00000097          	auipc	ra,0x0
     a84:	6e0080e7          	jalr	1760(ra) # 1160 <printf>
}
     a88:	70a2                	ld	ra,40(sp)
     a8a:	7402                	ld	s0,32(sp)
     a8c:	64e2                	ld	s1,24(sp)
     a8e:	6942                	ld	s2,16(sp)
     a90:	6145                	addi	sp,sp,48
     a92:	8082                	ret
    err("open");
     a94:	00001517          	auipc	a0,0x1
     a98:	90450513          	addi	a0,a0,-1788 # 1398 <malloc+0x180>
     a9c:	fffff097          	auipc	ra,0xfffff
     aa0:	564080e7          	jalr	1380(ra) # 0 <err>
    err("mmap (4)");
     aa4:	00001517          	auipc	a0,0x1
     aa8:	d9450513          	addi	a0,a0,-620 # 1838 <malloc+0x620>
     aac:	fffff097          	auipc	ra,0xfffff
     ab0:	554080e7          	jalr	1364(ra) # 0 <err>
    err("mmap (5)");
     ab4:	00001517          	auipc	a0,0x1
     ab8:	d9450513          	addi	a0,a0,-620 # 1848 <malloc+0x630>
     abc:	fffff097          	auipc	ra,0xfffff
     ac0:	544080e7          	jalr	1348(ra) # 0 <err>
    err("fork mismatch (1)");
     ac4:	00001517          	auipc	a0,0x1
     ac8:	d9450513          	addi	a0,a0,-620 # 1858 <malloc+0x640>
     acc:	fffff097          	auipc	ra,0xfffff
     ad0:	534080e7          	jalr	1332(ra) # 0 <err>
    err("fork");
     ad4:	00001517          	auipc	a0,0x1
     ad8:	d9c50513          	addi	a0,a0,-612 # 1870 <malloc+0x658>
     adc:	fffff097          	auipc	ra,0xfffff
     ae0:	524080e7          	jalr	1316(ra) # 0 <err>
    _v1(p1);
     ae4:	854a                	mv	a0,s2
     ae6:	fffff097          	auipc	ra,0xfffff
     aea:	558080e7          	jalr	1368(ra) # 3e <_v1>
    munmap(p1, PGSIZE); // just the first page
     aee:	6585                	lui	a1,0x1
     af0:	854a                	mv	a0,s2
     af2:	00000097          	auipc	ra,0x0
     af6:	38c080e7          	jalr	908(ra) # e7e <munmap>
    exit(0); // tell the parent that the mapping looks OK.
     afa:	4501                	li	a0,0
     afc:	00000097          	auipc	ra,0x0
     b00:	2da080e7          	jalr	730(ra) # dd6 <exit>
    printf("fork_test failed\n");
     b04:	00001517          	auipc	a0,0x1
     b08:	d7450513          	addi	a0,a0,-652 # 1878 <malloc+0x660>
     b0c:	00000097          	auipc	ra,0x0
     b10:	654080e7          	jalr	1620(ra) # 1160 <printf>
    exit(1);
     b14:	4505                	li	a0,1
     b16:	00000097          	auipc	ra,0x0
     b1a:	2c0080e7          	jalr	704(ra) # dd6 <exit>

0000000000000b1e <main>:
{
     b1e:	1141                	addi	sp,sp,-16
     b20:	e406                	sd	ra,8(sp)
     b22:	e022                	sd	s0,0(sp)
     b24:	0800                	addi	s0,sp,16
  mmap_test();
     b26:	fffff097          	auipc	ra,0xfffff
     b2a:	658080e7          	jalr	1624(ra) # 17e <mmap_test>
  fork_test();
     b2e:	00000097          	auipc	ra,0x0
     b32:	e62080e7          	jalr	-414(ra) # 990 <fork_test>
  printf("mmaptest: all tests succeeded\n");
     b36:	00001517          	auipc	a0,0x1
     b3a:	d6a50513          	addi	a0,a0,-662 # 18a0 <malloc+0x688>
     b3e:	00000097          	auipc	ra,0x0
     b42:	622080e7          	jalr	1570(ra) # 1160 <printf>
  exit(0);
     b46:	4501                	li	a0,0
     b48:	00000097          	auipc	ra,0x0
     b4c:	28e080e7          	jalr	654(ra) # dd6 <exit>

0000000000000b50 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     b50:	1141                	addi	sp,sp,-16
     b52:	e406                	sd	ra,8(sp)
     b54:	e022                	sd	s0,0(sp)
     b56:	0800                	addi	s0,sp,16
  extern int main();
  main();
     b58:	00000097          	auipc	ra,0x0
     b5c:	fc6080e7          	jalr	-58(ra) # b1e <main>
  exit(0);
     b60:	4501                	li	a0,0
     b62:	00000097          	auipc	ra,0x0
     b66:	274080e7          	jalr	628(ra) # dd6 <exit>

0000000000000b6a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b6a:	1141                	addi	sp,sp,-16
     b6c:	e422                	sd	s0,8(sp)
     b6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b70:	87aa                	mv	a5,a0
     b72:	0585                	addi	a1,a1,1 # 1001 <vprintf+0xad>
     b74:	0785                	addi	a5,a5,1
     b76:	fff5c703          	lbu	a4,-1(a1)
     b7a:	fee78fa3          	sb	a4,-1(a5)
     b7e:	fb75                	bnez	a4,b72 <strcpy+0x8>
    ;
  return os;
}
     b80:	6422                	ld	s0,8(sp)
     b82:	0141                	addi	sp,sp,16
     b84:	8082                	ret

0000000000000b86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b86:	1141                	addi	sp,sp,-16
     b88:	e422                	sd	s0,8(sp)
     b8a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b8c:	00054783          	lbu	a5,0(a0)
     b90:	cb91                	beqz	a5,ba4 <strcmp+0x1e>
     b92:	0005c703          	lbu	a4,0(a1)
     b96:	00f71763          	bne	a4,a5,ba4 <strcmp+0x1e>
    p++, q++;
     b9a:	0505                	addi	a0,a0,1
     b9c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b9e:	00054783          	lbu	a5,0(a0)
     ba2:	fbe5                	bnez	a5,b92 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     ba4:	0005c503          	lbu	a0,0(a1)
}
     ba8:	40a7853b          	subw	a0,a5,a0
     bac:	6422                	ld	s0,8(sp)
     bae:	0141                	addi	sp,sp,16
     bb0:	8082                	ret

0000000000000bb2 <strlen>:

uint
strlen(const char *s)
{
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e422                	sd	s0,8(sp)
     bb6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bb8:	00054783          	lbu	a5,0(a0)
     bbc:	cf91                	beqz	a5,bd8 <strlen+0x26>
     bbe:	0505                	addi	a0,a0,1
     bc0:	87aa                	mv	a5,a0
     bc2:	4685                	li	a3,1
     bc4:	9e89                	subw	a3,a3,a0
     bc6:	00f6853b          	addw	a0,a3,a5
     bca:	0785                	addi	a5,a5,1
     bcc:	fff7c703          	lbu	a4,-1(a5)
     bd0:	fb7d                	bnez	a4,bc6 <strlen+0x14>
    ;
  return n;
}
     bd2:	6422                	ld	s0,8(sp)
     bd4:	0141                	addi	sp,sp,16
     bd6:	8082                	ret
  for(n = 0; s[n]; n++)
     bd8:	4501                	li	a0,0
     bda:	bfe5                	j	bd2 <strlen+0x20>

0000000000000bdc <memset>:

void*
memset(void *dst, int c, uint n)
{
     bdc:	1141                	addi	sp,sp,-16
     bde:	e422                	sd	s0,8(sp)
     be0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     be2:	ca19                	beqz	a2,bf8 <memset+0x1c>
     be4:	87aa                	mv	a5,a0
     be6:	1602                	slli	a2,a2,0x20
     be8:	9201                	srli	a2,a2,0x20
     bea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bf2:	0785                	addi	a5,a5,1
     bf4:	fee79de3          	bne	a5,a4,bee <memset+0x12>
  }
  return dst;
}
     bf8:	6422                	ld	s0,8(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret

0000000000000bfe <strchr>:

char*
strchr(const char *s, char c)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c04:	00054783          	lbu	a5,0(a0)
     c08:	cb99                	beqz	a5,c1e <strchr+0x20>
    if(*s == c)
     c0a:	00f58763          	beq	a1,a5,c18 <strchr+0x1a>
  for(; *s; s++)
     c0e:	0505                	addi	a0,a0,1
     c10:	00054783          	lbu	a5,0(a0)
     c14:	fbfd                	bnez	a5,c0a <strchr+0xc>
      return (char*)s;
  return 0;
     c16:	4501                	li	a0,0
}
     c18:	6422                	ld	s0,8(sp)
     c1a:	0141                	addi	sp,sp,16
     c1c:	8082                	ret
  return 0;
     c1e:	4501                	li	a0,0
     c20:	bfe5                	j	c18 <strchr+0x1a>

0000000000000c22 <gets>:

char*
gets(char *buf, int max)
{
     c22:	711d                	addi	sp,sp,-96
     c24:	ec86                	sd	ra,88(sp)
     c26:	e8a2                	sd	s0,80(sp)
     c28:	e4a6                	sd	s1,72(sp)
     c2a:	e0ca                	sd	s2,64(sp)
     c2c:	fc4e                	sd	s3,56(sp)
     c2e:	f852                	sd	s4,48(sp)
     c30:	f456                	sd	s5,40(sp)
     c32:	f05a                	sd	s6,32(sp)
     c34:	ec5e                	sd	s7,24(sp)
     c36:	1080                	addi	s0,sp,96
     c38:	8baa                	mv	s7,a0
     c3a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c3c:	892a                	mv	s2,a0
     c3e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c40:	4aa9                	li	s5,10
     c42:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c44:	89a6                	mv	s3,s1
     c46:	2485                	addiw	s1,s1,1
     c48:	0344d863          	bge	s1,s4,c78 <gets+0x56>
    cc = read(0, &c, 1);
     c4c:	4605                	li	a2,1
     c4e:	faf40593          	addi	a1,s0,-81
     c52:	4501                	li	a0,0
     c54:	00000097          	auipc	ra,0x0
     c58:	19a080e7          	jalr	410(ra) # dee <read>
    if(cc < 1)
     c5c:	00a05e63          	blez	a0,c78 <gets+0x56>
    buf[i++] = c;
     c60:	faf44783          	lbu	a5,-81(s0)
     c64:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c68:	01578763          	beq	a5,s5,c76 <gets+0x54>
     c6c:	0905                	addi	s2,s2,1
     c6e:	fd679be3          	bne	a5,s6,c44 <gets+0x22>
  for(i=0; i+1 < max; ){
     c72:	89a6                	mv	s3,s1
     c74:	a011                	j	c78 <gets+0x56>
     c76:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c78:	99de                	add	s3,s3,s7
     c7a:	00098023          	sb	zero,0(s3)
  return buf;
}
     c7e:	855e                	mv	a0,s7
     c80:	60e6                	ld	ra,88(sp)
     c82:	6446                	ld	s0,80(sp)
     c84:	64a6                	ld	s1,72(sp)
     c86:	6906                	ld	s2,64(sp)
     c88:	79e2                	ld	s3,56(sp)
     c8a:	7a42                	ld	s4,48(sp)
     c8c:	7aa2                	ld	s5,40(sp)
     c8e:	7b02                	ld	s6,32(sp)
     c90:	6be2                	ld	s7,24(sp)
     c92:	6125                	addi	sp,sp,96
     c94:	8082                	ret

0000000000000c96 <stat>:

int
stat(const char *n, struct stat *st)
{
     c96:	1101                	addi	sp,sp,-32
     c98:	ec06                	sd	ra,24(sp)
     c9a:	e822                	sd	s0,16(sp)
     c9c:	e426                	sd	s1,8(sp)
     c9e:	e04a                	sd	s2,0(sp)
     ca0:	1000                	addi	s0,sp,32
     ca2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca4:	4581                	li	a1,0
     ca6:	00000097          	auipc	ra,0x0
     caa:	170080e7          	jalr	368(ra) # e16 <open>
  if(fd < 0)
     cae:	02054563          	bltz	a0,cd8 <stat+0x42>
     cb2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cb4:	85ca                	mv	a1,s2
     cb6:	00000097          	auipc	ra,0x0
     cba:	178080e7          	jalr	376(ra) # e2e <fstat>
     cbe:	892a                	mv	s2,a0
  close(fd);
     cc0:	8526                	mv	a0,s1
     cc2:	00000097          	auipc	ra,0x0
     cc6:	13c080e7          	jalr	316(ra) # dfe <close>
  return r;
}
     cca:	854a                	mv	a0,s2
     ccc:	60e2                	ld	ra,24(sp)
     cce:	6442                	ld	s0,16(sp)
     cd0:	64a2                	ld	s1,8(sp)
     cd2:	6902                	ld	s2,0(sp)
     cd4:	6105                	addi	sp,sp,32
     cd6:	8082                	ret
    return -1;
     cd8:	597d                	li	s2,-1
     cda:	bfc5                	j	cca <stat+0x34>

0000000000000cdc <atoi>:

int
atoi(const char *s)
{
     cdc:	1141                	addi	sp,sp,-16
     cde:	e422                	sd	s0,8(sp)
     ce0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce2:	00054683          	lbu	a3,0(a0)
     ce6:	fd06879b          	addiw	a5,a3,-48
     cea:	0ff7f793          	zext.b	a5,a5
     cee:	4625                	li	a2,9
     cf0:	02f66863          	bltu	a2,a5,d20 <atoi+0x44>
     cf4:	872a                	mv	a4,a0
  n = 0;
     cf6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cf8:	0705                	addi	a4,a4,1
     cfa:	0025179b          	slliw	a5,a0,0x2
     cfe:	9fa9                	addw	a5,a5,a0
     d00:	0017979b          	slliw	a5,a5,0x1
     d04:	9fb5                	addw	a5,a5,a3
     d06:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d0a:	00074683          	lbu	a3,0(a4)
     d0e:	fd06879b          	addiw	a5,a3,-48
     d12:	0ff7f793          	zext.b	a5,a5
     d16:	fef671e3          	bgeu	a2,a5,cf8 <atoi+0x1c>
  return n;
}
     d1a:	6422                	ld	s0,8(sp)
     d1c:	0141                	addi	sp,sp,16
     d1e:	8082                	ret
  n = 0;
     d20:	4501                	li	a0,0
     d22:	bfe5                	j	d1a <atoi+0x3e>

0000000000000d24 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d24:	1141                	addi	sp,sp,-16
     d26:	e422                	sd	s0,8(sp)
     d28:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d2a:	02b57463          	bgeu	a0,a1,d52 <memmove+0x2e>
    while(n-- > 0)
     d2e:	00c05f63          	blez	a2,d4c <memmove+0x28>
     d32:	1602                	slli	a2,a2,0x20
     d34:	9201                	srli	a2,a2,0x20
     d36:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d3a:	872a                	mv	a4,a0
      *dst++ = *src++;
     d3c:	0585                	addi	a1,a1,1
     d3e:	0705                	addi	a4,a4,1
     d40:	fff5c683          	lbu	a3,-1(a1)
     d44:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d48:	fee79ae3          	bne	a5,a4,d3c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d4c:	6422                	ld	s0,8(sp)
     d4e:	0141                	addi	sp,sp,16
     d50:	8082                	ret
    dst += n;
     d52:	00c50733          	add	a4,a0,a2
    src += n;
     d56:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d58:	fec05ae3          	blez	a2,d4c <memmove+0x28>
     d5c:	fff6079b          	addiw	a5,a2,-1 # fff <vprintf+0xab>
     d60:	1782                	slli	a5,a5,0x20
     d62:	9381                	srli	a5,a5,0x20
     d64:	fff7c793          	not	a5,a5
     d68:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d6a:	15fd                	addi	a1,a1,-1
     d6c:	177d                	addi	a4,a4,-1
     d6e:	0005c683          	lbu	a3,0(a1)
     d72:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d76:	fee79ae3          	bne	a5,a4,d6a <memmove+0x46>
     d7a:	bfc9                	j	d4c <memmove+0x28>

0000000000000d7c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d7c:	1141                	addi	sp,sp,-16
     d7e:	e422                	sd	s0,8(sp)
     d80:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d82:	ca05                	beqz	a2,db2 <memcmp+0x36>
     d84:	fff6069b          	addiw	a3,a2,-1
     d88:	1682                	slli	a3,a3,0x20
     d8a:	9281                	srli	a3,a3,0x20
     d8c:	0685                	addi	a3,a3,1
     d8e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d90:	00054783          	lbu	a5,0(a0)
     d94:	0005c703          	lbu	a4,0(a1)
     d98:	00e79863          	bne	a5,a4,da8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d9c:	0505                	addi	a0,a0,1
    p2++;
     d9e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     da0:	fed518e3          	bne	a0,a3,d90 <memcmp+0x14>
  }
  return 0;
     da4:	4501                	li	a0,0
     da6:	a019                	j	dac <memcmp+0x30>
      return *p1 - *p2;
     da8:	40e7853b          	subw	a0,a5,a4
}
     dac:	6422                	ld	s0,8(sp)
     dae:	0141                	addi	sp,sp,16
     db0:	8082                	ret
  return 0;
     db2:	4501                	li	a0,0
     db4:	bfe5                	j	dac <memcmp+0x30>

0000000000000db6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     db6:	1141                	addi	sp,sp,-16
     db8:	e406                	sd	ra,8(sp)
     dba:	e022                	sd	s0,0(sp)
     dbc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     dbe:	00000097          	auipc	ra,0x0
     dc2:	f66080e7          	jalr	-154(ra) # d24 <memmove>
}
     dc6:	60a2                	ld	ra,8(sp)
     dc8:	6402                	ld	s0,0(sp)
     dca:	0141                	addi	sp,sp,16
     dcc:	8082                	ret

0000000000000dce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dce:	4885                	li	a7,1
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     dd6:	4889                	li	a7,2
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <wait>:
.global wait
wait:
 li a7, SYS_wait
     dde:	488d                	li	a7,3
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     de6:	4891                	li	a7,4
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <read>:
.global read
read:
 li a7, SYS_read
     dee:	4895                	li	a7,5
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <write>:
.global write
write:
 li a7, SYS_write
     df6:	48c1                	li	a7,16
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <close>:
.global close
close:
 li a7, SYS_close
     dfe:	48d5                	li	a7,21
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e06:	4899                	li	a7,6
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e0e:	489d                	li	a7,7
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <open>:
.global open
open:
 li a7, SYS_open
     e16:	48bd                	li	a7,15
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e1e:	48c5                	li	a7,17
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e26:	48c9                	li	a7,18
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e2e:	48a1                	li	a7,8
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <link>:
.global link
link:
 li a7, SYS_link
     e36:	48cd                	li	a7,19
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e3e:	48d1                	li	a7,20
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e46:	48a5                	li	a7,9
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e4e:	48a9                	li	a7,10
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e56:	48ad                	li	a7,11
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e5e:	48b1                	li	a7,12
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e66:	48b5                	li	a7,13
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e6e:	48b9                	li	a7,14
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     e76:	48d9                	li	a7,22
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     e7e:	48dd                	li	a7,23
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e86:	1101                	addi	sp,sp,-32
     e88:	ec06                	sd	ra,24(sp)
     e8a:	e822                	sd	s0,16(sp)
     e8c:	1000                	addi	s0,sp,32
     e8e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e92:	4605                	li	a2,1
     e94:	fef40593          	addi	a1,s0,-17
     e98:	00000097          	auipc	ra,0x0
     e9c:	f5e080e7          	jalr	-162(ra) # df6 <write>
}
     ea0:	60e2                	ld	ra,24(sp)
     ea2:	6442                	ld	s0,16(sp)
     ea4:	6105                	addi	sp,sp,32
     ea6:	8082                	ret

0000000000000ea8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ea8:	7139                	addi	sp,sp,-64
     eaa:	fc06                	sd	ra,56(sp)
     eac:	f822                	sd	s0,48(sp)
     eae:	f426                	sd	s1,40(sp)
     eb0:	f04a                	sd	s2,32(sp)
     eb2:	ec4e                	sd	s3,24(sp)
     eb4:	0080                	addi	s0,sp,64
     eb6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     eb8:	c299                	beqz	a3,ebe <printint+0x16>
     eba:	0805c963          	bltz	a1,f4c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ebe:	2581                	sext.w	a1,a1
  neg = 0;
     ec0:	4881                	li	a7,0
     ec2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ec6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ec8:	2601                	sext.w	a2,a2
     eca:	00001517          	auipc	a0,0x1
     ece:	a5e50513          	addi	a0,a0,-1442 # 1928 <digits>
     ed2:	883a                	mv	a6,a4
     ed4:	2705                	addiw	a4,a4,1
     ed6:	02c5f7bb          	remuw	a5,a1,a2
     eda:	1782                	slli	a5,a5,0x20
     edc:	9381                	srli	a5,a5,0x20
     ede:	97aa                	add	a5,a5,a0
     ee0:	0007c783          	lbu	a5,0(a5)
     ee4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ee8:	0005879b          	sext.w	a5,a1
     eec:	02c5d5bb          	divuw	a1,a1,a2
     ef0:	0685                	addi	a3,a3,1
     ef2:	fec7f0e3          	bgeu	a5,a2,ed2 <printint+0x2a>
  if(neg)
     ef6:	00088c63          	beqz	a7,f0e <printint+0x66>
    buf[i++] = '-';
     efa:	fd070793          	addi	a5,a4,-48
     efe:	00878733          	add	a4,a5,s0
     f02:	02d00793          	li	a5,45
     f06:	fef70823          	sb	a5,-16(a4)
     f0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f0e:	02e05863          	blez	a4,f3e <printint+0x96>
     f12:	fc040793          	addi	a5,s0,-64
     f16:	00e78933          	add	s2,a5,a4
     f1a:	fff78993          	addi	s3,a5,-1
     f1e:	99ba                	add	s3,s3,a4
     f20:	377d                	addiw	a4,a4,-1
     f22:	1702                	slli	a4,a4,0x20
     f24:	9301                	srli	a4,a4,0x20
     f26:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f2a:	fff94583          	lbu	a1,-1(s2)
     f2e:	8526                	mv	a0,s1
     f30:	00000097          	auipc	ra,0x0
     f34:	f56080e7          	jalr	-170(ra) # e86 <putc>
  while(--i >= 0)
     f38:	197d                	addi	s2,s2,-1
     f3a:	ff3918e3          	bne	s2,s3,f2a <printint+0x82>
}
     f3e:	70e2                	ld	ra,56(sp)
     f40:	7442                	ld	s0,48(sp)
     f42:	74a2                	ld	s1,40(sp)
     f44:	7902                	ld	s2,32(sp)
     f46:	69e2                	ld	s3,24(sp)
     f48:	6121                	addi	sp,sp,64
     f4a:	8082                	ret
    x = -xx;
     f4c:	40b005bb          	negw	a1,a1
    neg = 1;
     f50:	4885                	li	a7,1
    x = -xx;
     f52:	bf85                	j	ec2 <printint+0x1a>

0000000000000f54 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f54:	7119                	addi	sp,sp,-128
     f56:	fc86                	sd	ra,120(sp)
     f58:	f8a2                	sd	s0,112(sp)
     f5a:	f4a6                	sd	s1,104(sp)
     f5c:	f0ca                	sd	s2,96(sp)
     f5e:	ecce                	sd	s3,88(sp)
     f60:	e8d2                	sd	s4,80(sp)
     f62:	e4d6                	sd	s5,72(sp)
     f64:	e0da                	sd	s6,64(sp)
     f66:	fc5e                	sd	s7,56(sp)
     f68:	f862                	sd	s8,48(sp)
     f6a:	f466                	sd	s9,40(sp)
     f6c:	f06a                	sd	s10,32(sp)
     f6e:	ec6e                	sd	s11,24(sp)
     f70:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f72:	0005c903          	lbu	s2,0(a1)
     f76:	18090f63          	beqz	s2,1114 <vprintf+0x1c0>
     f7a:	8aaa                	mv	s5,a0
     f7c:	8b32                	mv	s6,a2
     f7e:	00158493          	addi	s1,a1,1
  state = 0;
     f82:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f84:	02500a13          	li	s4,37
     f88:	4c55                	li	s8,21
     f8a:	00001c97          	auipc	s9,0x1
     f8e:	946c8c93          	addi	s9,s9,-1722 # 18d0 <malloc+0x6b8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     f92:	02800d93          	li	s11,40
  putc(fd, 'x');
     f96:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f98:	00001b97          	auipc	s7,0x1
     f9c:	990b8b93          	addi	s7,s7,-1648 # 1928 <digits>
     fa0:	a839                	j	fbe <vprintf+0x6a>
        putc(fd, c);
     fa2:	85ca                	mv	a1,s2
     fa4:	8556                	mv	a0,s5
     fa6:	00000097          	auipc	ra,0x0
     faa:	ee0080e7          	jalr	-288(ra) # e86 <putc>
     fae:	a019                	j	fb4 <vprintf+0x60>
    } else if(state == '%'){
     fb0:	01498d63          	beq	s3,s4,fca <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fb4:	0485                	addi	s1,s1,1
     fb6:	fff4c903          	lbu	s2,-1(s1)
     fba:	14090d63          	beqz	s2,1114 <vprintf+0x1c0>
    if(state == 0){
     fbe:	fe0999e3          	bnez	s3,fb0 <vprintf+0x5c>
      if(c == '%'){
     fc2:	ff4910e3          	bne	s2,s4,fa2 <vprintf+0x4e>
        state = '%';
     fc6:	89d2                	mv	s3,s4
     fc8:	b7f5                	j	fb4 <vprintf+0x60>
      if(c == 'd'){
     fca:	11490c63          	beq	s2,s4,10e2 <vprintf+0x18e>
     fce:	f9d9079b          	addiw	a5,s2,-99
     fd2:	0ff7f793          	zext.b	a5,a5
     fd6:	10fc6e63          	bltu	s8,a5,10f2 <vprintf+0x19e>
     fda:	f9d9079b          	addiw	a5,s2,-99
     fde:	0ff7f713          	zext.b	a4,a5
     fe2:	10ec6863          	bltu	s8,a4,10f2 <vprintf+0x19e>
     fe6:	00271793          	slli	a5,a4,0x2
     fea:	97e6                	add	a5,a5,s9
     fec:	439c                	lw	a5,0(a5)
     fee:	97e6                	add	a5,a5,s9
     ff0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     ff2:	008b0913          	addi	s2,s6,8
     ff6:	4685                	li	a3,1
     ff8:	4629                	li	a2,10
     ffa:	000b2583          	lw	a1,0(s6)
     ffe:	8556                	mv	a0,s5
    1000:	00000097          	auipc	ra,0x0
    1004:	ea8080e7          	jalr	-344(ra) # ea8 <printint>
    1008:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    100a:	4981                	li	s3,0
    100c:	b765                	j	fb4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    100e:	008b0913          	addi	s2,s6,8
    1012:	4681                	li	a3,0
    1014:	4629                	li	a2,10
    1016:	000b2583          	lw	a1,0(s6)
    101a:	8556                	mv	a0,s5
    101c:	00000097          	auipc	ra,0x0
    1020:	e8c080e7          	jalr	-372(ra) # ea8 <printint>
    1024:	8b4a                	mv	s6,s2
      state = 0;
    1026:	4981                	li	s3,0
    1028:	b771                	j	fb4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    102a:	008b0913          	addi	s2,s6,8
    102e:	4681                	li	a3,0
    1030:	866a                	mv	a2,s10
    1032:	000b2583          	lw	a1,0(s6)
    1036:	8556                	mv	a0,s5
    1038:	00000097          	auipc	ra,0x0
    103c:	e70080e7          	jalr	-400(ra) # ea8 <printint>
    1040:	8b4a                	mv	s6,s2
      state = 0;
    1042:	4981                	li	s3,0
    1044:	bf85                	j	fb4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1046:	008b0793          	addi	a5,s6,8
    104a:	f8f43423          	sd	a5,-120(s0)
    104e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1052:	03000593          	li	a1,48
    1056:	8556                	mv	a0,s5
    1058:	00000097          	auipc	ra,0x0
    105c:	e2e080e7          	jalr	-466(ra) # e86 <putc>
  putc(fd, 'x');
    1060:	07800593          	li	a1,120
    1064:	8556                	mv	a0,s5
    1066:	00000097          	auipc	ra,0x0
    106a:	e20080e7          	jalr	-480(ra) # e86 <putc>
    106e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1070:	03c9d793          	srli	a5,s3,0x3c
    1074:	97de                	add	a5,a5,s7
    1076:	0007c583          	lbu	a1,0(a5)
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	e0a080e7          	jalr	-502(ra) # e86 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1084:	0992                	slli	s3,s3,0x4
    1086:	397d                	addiw	s2,s2,-1
    1088:	fe0914e3          	bnez	s2,1070 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    108c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1090:	4981                	li	s3,0
    1092:	b70d                	j	fb4 <vprintf+0x60>
        s = va_arg(ap, char*);
    1094:	008b0913          	addi	s2,s6,8
    1098:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    109c:	02098163          	beqz	s3,10be <vprintf+0x16a>
        while(*s != 0){
    10a0:	0009c583          	lbu	a1,0(s3)
    10a4:	c5ad                	beqz	a1,110e <vprintf+0x1ba>
          putc(fd, *s);
    10a6:	8556                	mv	a0,s5
    10a8:	00000097          	auipc	ra,0x0
    10ac:	dde080e7          	jalr	-546(ra) # e86 <putc>
          s++;
    10b0:	0985                	addi	s3,s3,1
        while(*s != 0){
    10b2:	0009c583          	lbu	a1,0(s3)
    10b6:	f9e5                	bnez	a1,10a6 <vprintf+0x152>
        s = va_arg(ap, char*);
    10b8:	8b4a                	mv	s6,s2
      state = 0;
    10ba:	4981                	li	s3,0
    10bc:	bde5                	j	fb4 <vprintf+0x60>
          s = "(null)";
    10be:	00001997          	auipc	s3,0x1
    10c2:	80a98993          	addi	s3,s3,-2038 # 18c8 <malloc+0x6b0>
        while(*s != 0){
    10c6:	85ee                	mv	a1,s11
    10c8:	bff9                	j	10a6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10ca:	008b0913          	addi	s2,s6,8
    10ce:	000b4583          	lbu	a1,0(s6)
    10d2:	8556                	mv	a0,s5
    10d4:	00000097          	auipc	ra,0x0
    10d8:	db2080e7          	jalr	-590(ra) # e86 <putc>
    10dc:	8b4a                	mv	s6,s2
      state = 0;
    10de:	4981                	li	s3,0
    10e0:	bdd1                	j	fb4 <vprintf+0x60>
        putc(fd, c);
    10e2:	85d2                	mv	a1,s4
    10e4:	8556                	mv	a0,s5
    10e6:	00000097          	auipc	ra,0x0
    10ea:	da0080e7          	jalr	-608(ra) # e86 <putc>
      state = 0;
    10ee:	4981                	li	s3,0
    10f0:	b5d1                	j	fb4 <vprintf+0x60>
        putc(fd, '%');
    10f2:	85d2                	mv	a1,s4
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	d90080e7          	jalr	-624(ra) # e86 <putc>
        putc(fd, c);
    10fe:	85ca                	mv	a1,s2
    1100:	8556                	mv	a0,s5
    1102:	00000097          	auipc	ra,0x0
    1106:	d84080e7          	jalr	-636(ra) # e86 <putc>
      state = 0;
    110a:	4981                	li	s3,0
    110c:	b565                	j	fb4 <vprintf+0x60>
        s = va_arg(ap, char*);
    110e:	8b4a                	mv	s6,s2
      state = 0;
    1110:	4981                	li	s3,0
    1112:	b54d                	j	fb4 <vprintf+0x60>
    }
  }
}
    1114:	70e6                	ld	ra,120(sp)
    1116:	7446                	ld	s0,112(sp)
    1118:	74a6                	ld	s1,104(sp)
    111a:	7906                	ld	s2,96(sp)
    111c:	69e6                	ld	s3,88(sp)
    111e:	6a46                	ld	s4,80(sp)
    1120:	6aa6                	ld	s5,72(sp)
    1122:	6b06                	ld	s6,64(sp)
    1124:	7be2                	ld	s7,56(sp)
    1126:	7c42                	ld	s8,48(sp)
    1128:	7ca2                	ld	s9,40(sp)
    112a:	7d02                	ld	s10,32(sp)
    112c:	6de2                	ld	s11,24(sp)
    112e:	6109                	addi	sp,sp,128
    1130:	8082                	ret

0000000000001132 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1132:	715d                	addi	sp,sp,-80
    1134:	ec06                	sd	ra,24(sp)
    1136:	e822                	sd	s0,16(sp)
    1138:	1000                	addi	s0,sp,32
    113a:	e010                	sd	a2,0(s0)
    113c:	e414                	sd	a3,8(s0)
    113e:	e818                	sd	a4,16(s0)
    1140:	ec1c                	sd	a5,24(s0)
    1142:	03043023          	sd	a6,32(s0)
    1146:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    114a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    114e:	8622                	mv	a2,s0
    1150:	00000097          	auipc	ra,0x0
    1154:	e04080e7          	jalr	-508(ra) # f54 <vprintf>
}
    1158:	60e2                	ld	ra,24(sp)
    115a:	6442                	ld	s0,16(sp)
    115c:	6161                	addi	sp,sp,80
    115e:	8082                	ret

0000000000001160 <printf>:

void
printf(const char *fmt, ...)
{
    1160:	711d                	addi	sp,sp,-96
    1162:	ec06                	sd	ra,24(sp)
    1164:	e822                	sd	s0,16(sp)
    1166:	1000                	addi	s0,sp,32
    1168:	e40c                	sd	a1,8(s0)
    116a:	e810                	sd	a2,16(s0)
    116c:	ec14                	sd	a3,24(s0)
    116e:	f018                	sd	a4,32(s0)
    1170:	f41c                	sd	a5,40(s0)
    1172:	03043823          	sd	a6,48(s0)
    1176:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    117a:	00840613          	addi	a2,s0,8
    117e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1182:	85aa                	mv	a1,a0
    1184:	4505                	li	a0,1
    1186:	00000097          	auipc	ra,0x0
    118a:	dce080e7          	jalr	-562(ra) # f54 <vprintf>
}
    118e:	60e2                	ld	ra,24(sp)
    1190:	6442                	ld	s0,16(sp)
    1192:	6125                	addi	sp,sp,96
    1194:	8082                	ret

0000000000001196 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1196:	1141                	addi	sp,sp,-16
    1198:	e422                	sd	s0,8(sp)
    119a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a0:	00001797          	auipc	a5,0x1
    11a4:	e707b783          	ld	a5,-400(a5) # 2010 <freep>
    11a8:	a02d                	j	11d2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11aa:	4618                	lw	a4,8(a2)
    11ac:	9f2d                	addw	a4,a4,a1
    11ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11b2:	6398                	ld	a4,0(a5)
    11b4:	6310                	ld	a2,0(a4)
    11b6:	a83d                	j	11f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11b8:	ff852703          	lw	a4,-8(a0)
    11bc:	9f31                	addw	a4,a4,a2
    11be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11c0:	ff053683          	ld	a3,-16(a0)
    11c4:	a091                	j	1208 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11c6:	6398                	ld	a4,0(a5)
    11c8:	00e7e463          	bltu	a5,a4,11d0 <free+0x3a>
    11cc:	00e6ea63          	bltu	a3,a4,11e0 <free+0x4a>
{
    11d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d2:	fed7fae3          	bgeu	a5,a3,11c6 <free+0x30>
    11d6:	6398                	ld	a4,0(a5)
    11d8:	00e6e463          	bltu	a3,a4,11e0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11dc:	fee7eae3          	bltu	a5,a4,11d0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11e0:	ff852583          	lw	a1,-8(a0)
    11e4:	6390                	ld	a2,0(a5)
    11e6:	02059813          	slli	a6,a1,0x20
    11ea:	01c85713          	srli	a4,a6,0x1c
    11ee:	9736                	add	a4,a4,a3
    11f0:	fae60de3          	beq	a2,a4,11aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11f8:	4790                	lw	a2,8(a5)
    11fa:	02061593          	slli	a1,a2,0x20
    11fe:	01c5d713          	srli	a4,a1,0x1c
    1202:	973e                	add	a4,a4,a5
    1204:	fae68ae3          	beq	a3,a4,11b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1208:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    120a:	00001717          	auipc	a4,0x1
    120e:	e0f73323          	sd	a5,-506(a4) # 2010 <freep>
}
    1212:	6422                	ld	s0,8(sp)
    1214:	0141                	addi	sp,sp,16
    1216:	8082                	ret

0000000000001218 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1218:	7139                	addi	sp,sp,-64
    121a:	fc06                	sd	ra,56(sp)
    121c:	f822                	sd	s0,48(sp)
    121e:	f426                	sd	s1,40(sp)
    1220:	f04a                	sd	s2,32(sp)
    1222:	ec4e                	sd	s3,24(sp)
    1224:	e852                	sd	s4,16(sp)
    1226:	e456                	sd	s5,8(sp)
    1228:	e05a                	sd	s6,0(sp)
    122a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    122c:	02051493          	slli	s1,a0,0x20
    1230:	9081                	srli	s1,s1,0x20
    1232:	04bd                	addi	s1,s1,15
    1234:	8091                	srli	s1,s1,0x4
    1236:	0014899b          	addiw	s3,s1,1
    123a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    123c:	00001517          	auipc	a0,0x1
    1240:	dd453503          	ld	a0,-556(a0) # 2010 <freep>
    1244:	c515                	beqz	a0,1270 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1246:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1248:	4798                	lw	a4,8(a5)
    124a:	02977f63          	bgeu	a4,s1,1288 <malloc+0x70>
    124e:	8a4e                	mv	s4,s3
    1250:	0009871b          	sext.w	a4,s3
    1254:	6685                	lui	a3,0x1
    1256:	00d77363          	bgeu	a4,a3,125c <malloc+0x44>
    125a:	6a05                	lui	s4,0x1
    125c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1260:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1264:	00001917          	auipc	s2,0x1
    1268:	dac90913          	addi	s2,s2,-596 # 2010 <freep>
  if(p == (char*)-1)
    126c:	5afd                	li	s5,-1
    126e:	a895                	j	12e2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1270:	00003797          	auipc	a5,0x3
    1274:	1b078793          	addi	a5,a5,432 # 4420 <base>
    1278:	00001717          	auipc	a4,0x1
    127c:	d8f73c23          	sd	a5,-616(a4) # 2010 <freep>
    1280:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1282:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1286:	b7e1                	j	124e <malloc+0x36>
      if(p->s.size == nunits)
    1288:	02e48c63          	beq	s1,a4,12c0 <malloc+0xa8>
        p->s.size -= nunits;
    128c:	4137073b          	subw	a4,a4,s3
    1290:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1292:	02071693          	slli	a3,a4,0x20
    1296:	01c6d713          	srli	a4,a3,0x1c
    129a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    129c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12a0:	00001717          	auipc	a4,0x1
    12a4:	d6a73823          	sd	a0,-656(a4) # 2010 <freep>
      return (void*)(p + 1);
    12a8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12ac:	70e2                	ld	ra,56(sp)
    12ae:	7442                	ld	s0,48(sp)
    12b0:	74a2                	ld	s1,40(sp)
    12b2:	7902                	ld	s2,32(sp)
    12b4:	69e2                	ld	s3,24(sp)
    12b6:	6a42                	ld	s4,16(sp)
    12b8:	6aa2                	ld	s5,8(sp)
    12ba:	6b02                	ld	s6,0(sp)
    12bc:	6121                	addi	sp,sp,64
    12be:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12c0:	6398                	ld	a4,0(a5)
    12c2:	e118                	sd	a4,0(a0)
    12c4:	bff1                	j	12a0 <malloc+0x88>
  hp->s.size = nu;
    12c6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12ca:	0541                	addi	a0,a0,16
    12cc:	00000097          	auipc	ra,0x0
    12d0:	eca080e7          	jalr	-310(ra) # 1196 <free>
  return freep;
    12d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12d8:	d971                	beqz	a0,12ac <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12dc:	4798                	lw	a4,8(a5)
    12de:	fa9775e3          	bgeu	a4,s1,1288 <malloc+0x70>
    if(p == freep)
    12e2:	00093703          	ld	a4,0(s2)
    12e6:	853e                	mv	a0,a5
    12e8:	fef719e3          	bne	a4,a5,12da <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12ec:	8552                	mv	a0,s4
    12ee:	00000097          	auipc	ra,0x0
    12f2:	b70080e7          	jalr	-1168(ra) # e5e <sbrk>
  if(p == (char*)-1)
    12f6:	fd5518e3          	bne	a0,s5,12c6 <malloc+0xae>
        return 0;
    12fa:	4501                	li	a0,0
    12fc:	bf45                	j	12ac <malloc+0x94>
