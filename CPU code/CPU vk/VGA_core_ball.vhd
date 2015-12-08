--创建日期：2015/05/24
--目标芯片: EP2C20Q240C8
--时钟选择: clk = 25M
--完成者：钱雨杰

package data_type is
    type int_array is array(1 to 8) of integer range 0 to 1000;
end package data_type;

use work.data_type.all;

library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.numeric_std.all;
use		ieee.std_logic_arith.all;

entity vga_core_ball is
	 port(
			reset       :         in  STD_LOGIC;
			clk         :		    in std_logic;  --25M时钟输入
			r,g,b       :         out STD_LOGIC_vector(2 downto 0);
			vector_x    :         in std_logic_vector(9 downto 0);
			vector_y    :         in std_logic_vector(9 downto 0);
			num_c       :         in integer range 0 to 100;
			theta_c     :         in int_array;
			mtime       :         in integer range 0 to 1000
	  );
end vga_core_ball;

architecture behavior of vga_core_ball is
	
	component circle is
		port (
			enable : in std_logic;
			x0, y0, x, y : in integer range 0 to 1000;
			r2 : in integer range 0 to 2000;
			flag : out std_logic
		);
	end component;
	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	type int_array_big is array(1 to 8) of integer range -1000000 to 1000000;
	signal tmp_line : int_array_big;
	
	signal ce : std_logic_vector(1 to 8) := "00000000";
	signal cx, cy : int_array;
	signal iswhite : std_logic := '0';
	signal whitecolor : std_logic_vector(2 downto 0) := "000";
	signal calc_cnt : integer range 0 to 30 := 0;
	signal curtime : integer range 0 to 1000 := 1000;
	signal curnum : integer range 0 to 100 := 100;

	function cos(th : in integer range 0 to 720) return integer is
	begin
		case th is
			when 0 => return 200; when 1 => return 200; when 2 => return 200; 
			when 3 => return 200; when 4 => return 200; when 5 => return 200; 
			when 6 => return 200; when 7 => return 200; when 8 => return 200; 
			when 9 => return 199; when 10 => return 199; when 11 => return 199; 
			when 12 => return 199; when 13 => return 199; when 14 => return 199; 
			when 15 => return 198; when 16 => return 198; when 17 => return 198; 
			when 18 => return 198; when 19 => return 197; when 20 => return 197; 
			when 21 => return 197; when 22 => return 196; when 23 => return 196; 
			when 24 => return 196; when 25 => return 195; when 26 => return 195; 
			when 27 => return 194; when 28 => return 194; when 29 => return 194; 
			when 30 => return 193; when 31 => return 193; when 32 => return 192; 
			when 33 => return 192; when 34 => return 191; when 35 => return 191; 
			when 36 => return 190; when 37 => return 190; when 38 => return 189; 
			when 39 => return 189; when 40 => return 188; when 41 => return 187; 
			when 42 => return 187; when 43 => return 186; when 44 => return 185; 
			when 45 => return 185; when 46 => return 184; when 47 => return 183; 
			when 48 => return 183; when 49 => return 182; when 50 => return 181; 
			when 51 => return 181; when 52 => return 180; when 53 => return 179; 
			when 54 => return 178; when 55 => return 177; when 56 => return 177; 
			when 57 => return 176; when 58 => return 175; when 59 => return 174; 
			when 60 => return 173; when 61 => return 172; when 62 => return 171; 
			when 63 => return 171; when 64 => return 170; when 65 => return 169; 
			when 66 => return 168; when 67 => return 167; when 68 => return 166; 
			when 69 => return 165; when 70 => return 164; when 71 => return 163; 
			when 72 => return 162; when 73 => return 161; when 74 => return 160; 
			when 75 => return 159; when 76 => return 158; when 77 => return 157; 
			when 78 => return 155; when 79 => return 154; when 80 => return 153; 
			when 81 => return 152; when 82 => return 151; when 83 => return 150; 
			when 84 => return 149; when 85 => return 147; when 86 => return 146; 
			when 87 => return 145; when 88 => return 144; when 89 => return 143; 
			when 90 => return 141; when 91 => return 140; when 92 => return 139; 
			when 93 => return 138; when 94 => return 136; when 95 => return 135; 
			when 96 => return 134; when 97 => return 133; when 98 => return 131; 
			when 99 => return 130; when 100 => return 129; when 101 => return 127; 
			when 102 => return 126; when 103 => return 125; when 104 => return 123; 
			when 105 => return 122; when 106 => return 120; when 107 => return 119; 
			when 108 => return 118; when 109 => return 116; when 110 => return 115; 
			when 111 => return 113; when 112 => return 112; when 113 => return 110; 
			when 114 => return 109; when 115 => return 107; when 116 => return 106; 
			when 117 => return 104; when 118 => return 103; when 119 => return 102; 
			when 120 => return 100; when 121 => return 98; when 122 => return 97; 
			when 123 => return 95; when 124 => return 94; when 125 => return 92; 
			when 126 => return 91; when 127 => return 89; when 128 => return 88; 
			when 129 => return 86; when 130 => return 85; when 131 => return 83; 
			when 132 => return 81; when 133 => return 80; when 134 => return 78; 
			when 135 => return 77; when 136 => return 75; when 137 => return 73; 
			when 138 => return 72; when 139 => return 70; when 140 => return 68; 
			when 141 => return 67; when 142 => return 65; when 143 => return 63; 
			when 144 => return 62; when 145 => return 60; when 146 => return 58; 
			when 147 => return 57; when 148 => return 55; when 149 => return 53; 
			when 150 => return 52; when 151 => return 50; when 152 => return 48; 
			when 153 => return 47; when 154 => return 45; when 155 => return 43; 
			when 156 => return 42; when 157 => return 40; when 158 => return 38; 
			when 159 => return 36; when 160 => return 35; when 161 => return 33; 
			when 162 => return 31; when 163 => return 30; when 164 => return 28; 
			when 165 => return 26; when 166 => return 24; when 167 => return 23; 
			when 168 => return 21; when 169 => return 19; when 170 => return 17; 
			when 171 => return 16; when 172 => return 14; when 173 => return 12; 
			when 174 => return 10; when 175 => return 9; when 176 => return 7; 
			when 177 => return 5; when 178 => return 3; when 179 => return 2; 
			when 180 => return 0; when 181 => return -2; when 182 => return -3; 
			when 183 => return -5; when 184 => return -7; when 185 => return -9; 
			when 186 => return -10; when 187 => return -12; when 188 => return -14; 
			when 189 => return -16; when 190 => return -17; when 191 => return -19; 
			when 192 => return -21; when 193 => return -23; when 194 => return -24; 
			when 195 => return -26; when 196 => return -28; when 197 => return -30; 
			when 198 => return -31; when 199 => return -33; when 200 => return -35; 
			when 201 => return -36; when 202 => return -38; when 203 => return -40; 
			when 204 => return -42; when 205 => return -43; when 206 => return -45; 
			when 207 => return -47; when 208 => return -48; when 209 => return -50; 
			when 210 => return -52; when 211 => return -53; when 212 => return -55; 
			when 213 => return -57; when 214 => return -58; when 215 => return -60; 
			when 216 => return -62; when 217 => return -63; when 218 => return -65; 
			when 219 => return -67; when 220 => return -68; when 221 => return -70; 
			when 222 => return -72; when 223 => return -73; when 224 => return -75; 
			when 225 => return -77; when 226 => return -78; when 227 => return -80; 
			when 228 => return -81; when 229 => return -83; when 230 => return -85; 
			when 231 => return -86; when 232 => return -88; when 233 => return -89; 
			when 234 => return -91; when 235 => return -92; when 236 => return -94; 
			when 237 => return -95; when 238 => return -97; when 239 => return -98; 
			when 240 => return -100; when 241 => return -102; when 242 => return -103; 
			when 243 => return -104; when 244 => return -106; when 245 => return -107; 
			when 246 => return -109; when 247 => return -110; when 248 => return -112; 
			when 249 => return -113; when 250 => return -115; when 251 => return -116; 
			when 252 => return -118; when 253 => return -119; when 254 => return -120; 
			when 255 => return -122; when 256 => return -123; when 257 => return -125; 
			when 258 => return -126; when 259 => return -127; when 260 => return -129; 
			when 261 => return -130; when 262 => return -131; when 263 => return -133; 
			when 264 => return -134; when 265 => return -135; when 266 => return -136; 
			when 267 => return -138; when 268 => return -139; when 269 => return -140; 
			when 270 => return -141; when 271 => return -143; when 272 => return -144; 
			when 273 => return -145; when 274 => return -146; when 275 => return -147; 
			when 276 => return -149; when 277 => return -150; when 278 => return -151; 
			when 279 => return -152; when 280 => return -153; when 281 => return -154; 
			when 282 => return -155; when 283 => return -157; when 284 => return -158; 
			when 285 => return -159; when 286 => return -160; when 287 => return -161; 
			when 288 => return -162; when 289 => return -163; when 290 => return -164; 
			when 291 => return -165; when 292 => return -166; when 293 => return -167; 
			when 294 => return -168; when 295 => return -169; when 296 => return -170; 
			when 297 => return -171; when 298 => return -171; when 299 => return -172; 
			when 300 => return -173; when 301 => return -174; when 302 => return -175; 
			when 303 => return -176; when 304 => return -177; when 305 => return -177; 
			when 306 => return -178; when 307 => return -179; when 308 => return -180; 
			when 309 => return -181; when 310 => return -181; when 311 => return -182; 
			when 312 => return -183; when 313 => return -183; when 314 => return -184; 
			when 315 => return -185; when 316 => return -185; when 317 => return -186; 
			when 318 => return -187; when 319 => return -187; when 320 => return -188; 
			when 321 => return -189; when 322 => return -189; when 323 => return -190; 
			when 324 => return -190; when 325 => return -191; when 326 => return -191; 
			when 327 => return -192; when 328 => return -192; when 329 => return -193; 
			when 330 => return -193; when 331 => return -194; when 332 => return -194; 
			when 333 => return -194; when 334 => return -195; when 335 => return -195; 
			when 336 => return -196; when 337 => return -196; when 338 => return -196; 
			when 339 => return -197; when 340 => return -197; when 341 => return -197; 
			when 342 => return -198; when 343 => return -198; when 344 => return -198; 
			when 345 => return -198; when 346 => return -199; when 347 => return -199; 
			when 348 => return -199; when 349 => return -199; when 350 => return -199; 
			when 351 => return -199; when 352 => return -200; when 353 => return -200; 
			when 354 => return -200; when 355 => return -200; when 356 => return -200; 
			when 357 => return -200; when 358 => return -200; when 359 => return -200; 
			when 360 => return -200; when 361 => return -200; when 362 => return -200; 
			when 363 => return -200; when 364 => return -200; when 365 => return -200; 
			when 366 => return -200; when 367 => return -200; when 368 => return -200; 
			when 369 => return -199; when 370 => return -199; when 371 => return -199; 
			when 372 => return -199; when 373 => return -199; when 374 => return -199; 
			when 375 => return -198; when 376 => return -198; when 377 => return -198; 
			when 378 => return -198; when 379 => return -197; when 380 => return -197; 
			when 381 => return -197; when 382 => return -196; when 383 => return -196; 
			when 384 => return -196; when 385 => return -195; when 386 => return -195; 
			when 387 => return -194; when 388 => return -194; when 389 => return -194; 
			when 390 => return -193; when 391 => return -193; when 392 => return -192; 
			when 393 => return -192; when 394 => return -191; when 395 => return -191; 
			when 396 => return -190; when 397 => return -190; when 398 => return -189; 
			when 399 => return -189; when 400 => return -188; when 401 => return -187; 
			when 402 => return -187; when 403 => return -186; when 404 => return -185; 
			when 405 => return -185; when 406 => return -184; when 407 => return -183; 
			when 408 => return -183; when 409 => return -182; when 410 => return -181; 
			when 411 => return -181; when 412 => return -180; when 413 => return -179; 
			when 414 => return -178; when 415 => return -177; when 416 => return -177; 
			when 417 => return -176; when 418 => return -175; when 419 => return -174; 
			when 420 => return -173; when 421 => return -172; when 422 => return -171; 
			when 423 => return -171; when 424 => return -170; when 425 => return -169; 
			when 426 => return -168; when 427 => return -167; when 428 => return -166; 
			when 429 => return -165; when 430 => return -164; when 431 => return -163; 
			when 432 => return -162; when 433 => return -161; when 434 => return -160; 
			when 435 => return -159; when 436 => return -158; when 437 => return -157; 
			when 438 => return -155; when 439 => return -154; when 440 => return -153; 
			when 441 => return -152; when 442 => return -151; when 443 => return -150; 
			when 444 => return -149; when 445 => return -147; when 446 => return -146; 
			when 447 => return -145; when 448 => return -144; when 449 => return -143; 
			when 450 => return -141; when 451 => return -140; when 452 => return -139; 
			when 453 => return -138; when 454 => return -136; when 455 => return -135; 
			when 456 => return -134; when 457 => return -133; when 458 => return -131; 
			when 459 => return -130; when 460 => return -129; when 461 => return -127; 
			when 462 => return -126; when 463 => return -125; when 464 => return -123; 
			when 465 => return -122; when 466 => return -120; when 467 => return -119; 
			when 468 => return -118; when 469 => return -116; when 470 => return -115; 
			when 471 => return -113; when 472 => return -112; when 473 => return -110; 
			when 474 => return -109; when 475 => return -107; when 476 => return -106; 
			when 477 => return -104; when 478 => return -103; when 479 => return -102; 
			when 480 => return -100; when 481 => return -98; when 482 => return -97; 
			when 483 => return -95; when 484 => return -94; when 485 => return -92; 
			when 486 => return -91; when 487 => return -89; when 488 => return -88; 
			when 489 => return -86; when 490 => return -85; when 491 => return -83; 
			when 492 => return -81; when 493 => return -80; when 494 => return -78; 
			when 495 => return -77; when 496 => return -75; when 497 => return -73; 
			when 498 => return -72; when 499 => return -70; when 500 => return -68; 
			when 501 => return -67; when 502 => return -65; when 503 => return -63; 
			when 504 => return -62; when 505 => return -60; when 506 => return -58; 
			when 507 => return -57; when 508 => return -55; when 509 => return -53; 
			when 510 => return -52; when 511 => return -50; when 512 => return -48; 
			when 513 => return -47; when 514 => return -45; when 515 => return -43; 
			when 516 => return -42; when 517 => return -40; when 518 => return -38; 
			when 519 => return -36; when 520 => return -35; when 521 => return -33; 
			when 522 => return -31; when 523 => return -30; when 524 => return -28; 
			when 525 => return -26; when 526 => return -24; when 527 => return -23; 
			when 528 => return -21; when 529 => return -19; when 530 => return -17; 
			when 531 => return -16; when 532 => return -14; when 533 => return -12; 
			when 534 => return -10; when 535 => return -9; when 536 => return -7; 
			when 537 => return -5; when 538 => return -3; when 539 => return -2; 
			when 540 => return -0; when 541 => return 2; when 542 => return 3; 
			when 543 => return 5; when 544 => return 7; when 545 => return 9; 
			when 546 => return 10; when 547 => return 12; when 548 => return 14; 
			when 549 => return 16; when 550 => return 17; when 551 => return 19; 
			when 552 => return 21; when 553 => return 23; when 554 => return 24; 
			when 555 => return 26; when 556 => return 28; when 557 => return 30; 
			when 558 => return 31; when 559 => return 33; when 560 => return 35; 
			when 561 => return 36; when 562 => return 38; when 563 => return 40; 
			when 564 => return 42; when 565 => return 43; when 566 => return 45; 
			when 567 => return 47; when 568 => return 48; when 569 => return 50; 
			when 570 => return 52; when 571 => return 53; when 572 => return 55; 
			when 573 => return 57; when 574 => return 58; when 575 => return 60; 
			when 576 => return 62; when 577 => return 63; when 578 => return 65; 
			when 579 => return 67; when 580 => return 68; when 581 => return 70; 
			when 582 => return 72; when 583 => return 73; when 584 => return 75; 
			when 585 => return 77; when 586 => return 78; when 587 => return 80; 
			when 588 => return 81; when 589 => return 83; when 590 => return 85; 
			when 591 => return 86; when 592 => return 88; when 593 => return 89; 
			when 594 => return 91; when 595 => return 92; when 596 => return 94; 
			when 597 => return 95; when 598 => return 97; when 599 => return 98; 
			when 600 => return 100; when 601 => return 102; when 602 => return 103; 
			when 603 => return 104; when 604 => return 106; when 605 => return 107; 
			when 606 => return 109; when 607 => return 110; when 608 => return 112; 
			when 609 => return 113; when 610 => return 115; when 611 => return 116; 
			when 612 => return 118; when 613 => return 119; when 614 => return 120; 
			when 615 => return 122; when 616 => return 123; when 617 => return 125; 
			when 618 => return 126; when 619 => return 127; when 620 => return 129; 
			when 621 => return 130; when 622 => return 131; when 623 => return 133; 
			when 624 => return 134; when 625 => return 135; when 626 => return 136; 
			when 627 => return 138; when 628 => return 139; when 629 => return 140; 
			when 630 => return 141; when 631 => return 143; when 632 => return 144; 
			when 633 => return 145; when 634 => return 146; when 635 => return 147; 
			when 636 => return 149; when 637 => return 150; when 638 => return 151; 
			when 639 => return 152; when 640 => return 153; when 641 => return 154; 
			when 642 => return 155; when 643 => return 157; when 644 => return 158; 
			when 645 => return 159; when 646 => return 160; when 647 => return 161; 
			when 648 => return 162; when 649 => return 163; when 650 => return 164; 
			when 651 => return 165; when 652 => return 166; when 653 => return 167; 
			when 654 => return 168; when 655 => return 169; when 656 => return 170; 
			when 657 => return 171; when 658 => return 171; when 659 => return 172; 
			when 660 => return 173; when 661 => return 174; when 662 => return 175; 
			when 663 => return 176; when 664 => return 177; when 665 => return 177; 
			when 666 => return 178; when 667 => return 179; when 668 => return 180; 
			when 669 => return 181; when 670 => return 181; when 671 => return 182; 
			when 672 => return 183; when 673 => return 183; when 674 => return 184; 
			when 675 => return 185; when 676 => return 185; when 677 => return 186; 
			when 678 => return 187; when 679 => return 187; when 680 => return 188; 
			when 681 => return 189; when 682 => return 189; when 683 => return 190; 
			when 684 => return 190; when 685 => return 191; when 686 => return 191; 
			when 687 => return 192; when 688 => return 192; when 689 => return 193; 
			when 690 => return 193; when 691 => return 194; when 692 => return 194; 
			when 693 => return 194; when 694 => return 195; when 695 => return 195; 
			when 696 => return 196; when 697 => return 196; when 698 => return 196; 
			when 699 => return 197; when 700 => return 197; when 701 => return 197; 
			when 702 => return 198; when 703 => return 198; when 704 => return 198; 
			when 705 => return 198; when 706 => return 199; when 707 => return 199; 
			when 708 => return 199; when 709 => return 199; when 710 => return 199; 
			when 711 => return 199; when 712 => return 200; when 713 => return 200; 
			when 714 => return 200; when 715 => return 200; when 716 => return 200; 
			when 717 => return 200; when 718 => return 200; when 719 => return 200; 
			when others => return 0;
		end case;
	end;

	function anticircle(x,y : in integer range -800 to 800; r2 : in integer range 0 to 10000)  --圆的消锯齿
		return integer is
		variable res : integer range 0 to 16;
		variable tmp : integer range -1000 to 10000;
		variable rr2 : integer range 0 to 10000;
	begin
		res := 0;
		if x < -45 or x > 45 or y < -45 or y > 45 then
			return res;
		end if;
		tmp := x * x + y * y;
		if (tmp < r2) then res := res + 2; end if;
		tmp := tmp + tmp;
		rr2 := r2 + r2;
		if (tmp - x - y < rr2) then res := res + 2; end if;
		if (tmp - x + y < rr2) then res := res + 2; end if;
		if (tmp + x - y < rr2) then res := res + 2; end if;
		if (tmp + x + y < rr2) then res := res + 2; end if;
		if res > 7 then
			return 7;
		else
			return res;
		end if;
 	end;
 	
 	function antiline(tmp : in integer range -1000000 to 1000000) return integer is  --直线的消锯齿
	begin
		if tmp > 300 or tmp < -300 then return 0; end if;
		if tmp > 250 or tmp < -250 then return 2; end if;
		if tmp > 200 or tmp < -200 then return 4; end if;
		if tmp > 150 or tmp < -150 then return 6; end if;
		return 7;
	end;
 	
begin

 -----------------------------------------------------------------------	
	process(reset,clk) -- XY坐标定位控制
	begin  
		if reset='0' then
			r1 <= "000";
			g1 <= "000";
			b1 <= "000";	
		elsif(clk'event and clk='1')then
		 	if vector_x < 2 or vector_x > 638 or vector_y < 2 or vector_y > 478 then
				r1 <= "000";
				g1 <= "000";
				b1 <= "000";
			else
				if iswhite = '1' then
					r1 <= whitecolor;
					g1 <= whitecolor;
					b1 <= whitecolor;
				else
					r1 <= "000";
					g1 <= "000";
					b1 <= "000";
				end if;
			end if;
		end if;
	end process;	

	process (clk)  --根据坐标计算色彩
		variable vx, vy: integer range -800 to 800;
		variable dx, dy: integer range -800 to 800;
		variable x, y : integer range 0 to 800;
		variable i : integer range 0 to 8;
		variable color : integer range 0 to 7;
	begin
		if clk'event and clk = '1' then
			vx := conv_integer("0" & vector_x);
			vy := conv_integer("0" & vector_y);
			if vector_x > 650 and vector_x <= 658 then
				i := vx - 650;
				if ce(i) = '1' then
					tmp_line(i) <= (320-cx(i))*(vy+1)+240*cx(i)-320*cy(i);
				end if;
			end if;
			if vx >= 320 then
				dx := vx - 320;
			else
				dx := 320 - vx;
			end if;
			if dy >= 240 then
				dy := vy - 240;
			else
				dy := 240 - vy;
			end if;
			iswhite <= '0';
			color := anticircle(dx, dy, 1600);
			if (color /= 0) then
				iswhite <= '1';
				whitecolor <= conv_std_logic_vector(color, 3);
			else
				for i in 1 to 8 loop
					if ce(i) = '1' and color /= 7 then
						x := cx(i); y := cy(i);
						if vx >= x then
							dx := vx - x;
						else
							dx := x - vx;
						end if;
						if vy >= y then
							dy := vy - y;
						else
							dy := y - vy;
						end if;
						color := anticircle(dx, dy, 255);
						if (color /= 0) then
							iswhite <= '1';	
							whitecolor <= conv_std_logic_vector(color, 3);
						else
							if color /= 7 and
							(((vector_x >= x and vector_x < 322) or (vector_x >= 319 and vector_x < x + 1))and
							((vector_y >= y and vector_y < 242) or (vector_y >= 239 and vector_y < y + 1)))
							then
								color := antiline(tmp_line(i));
								if (color /= 0) then
									iswhite <= '1';
									whitecolor <= conv_std_logic_vector(color, 3);
								end if;
							end if;
						end if;
					end if;
				end loop;
			end if;
			if vector_x < 650 then
				for i in 1 to 8 loop
					if ce(i) = '1' then
						tmp_line(i) <= tmp_line(i) + cy(i) - 240;
					end if;
				end loop;
			end if;	
		end if;
	end process;

	-----------------------------------------------------------------------
	--色彩输出
	r	<= r1;
	g	<= g1;
	b	<= b1;
	
	------------------------------------------------------------------------
	
	process (clk)  --根据角度信息计算坐标，通过状态机异步计算
		variable th, th2 : integer;
		variable x, y : integer;
	begin
		if clk'event and clk = '1' then
			if calc_cnt = 0 then
				if (mtime /= curtime or num_c /= curnum) then
					calc_cnt <= 1;
					curtime <= mtime;
					curnum <= num_c;
				end if;
			else
				if calc_cnt <= num_c then
					th := theta_c(calc_cnt) + mtime;
					if th >= 720 then th:= th - 720; end if;
					th2 := (900 - th);
					if th2 >= 720 then th2 := th2 - 720; end if;
					
					if th <= 180 then
						x := 320 + cos(th);
					elsif th <= 360 then
						x := 320 - cos(360 - th);
					elsif th <= 540 then
						x := 320 - cos(th - 360);
					else
						x := 320 + cos(th);
					end if;		
					
					cx(calc_cnt) <= x;
					
					if th2 <= 180 then
						y := 240 + cos(th2);
					elsif th2 <= 360 then
						y := 240 - cos(360 - th2);
					elsif th2 <= 540 then
						y := 240 - cos(th2 - 360);
					else
						y := 240 + cos(th2);
					end if;
					
					cy(calc_cnt) <= y;
					ce(calc_cnt) <= '1';
					calc_cnt <= calc_cnt + 1;
				elsif calc_cnt <= 8 then
					ce(calc_cnt) <= '0';
					calc_cnt <= calc_cnt + 1;
				else
					calc_cnt <= 0;
				end if;
			end if;
		end if;
	end process;

end behavior;

