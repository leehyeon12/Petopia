show user;
-- #업데이트 내역
-- [190106] 계정관련 쿼리문, 예약결제환불 관련 테이블 및 시퀀스
-- [190107] 1; 팀별 쿼리 병합
-- [190107] 2; 기업회원상세 테이블의 특이사항을 빼고 찾아오는길 컬럼 추가
-- [190111] member , biz_info 컬럼 추가 (이미지 파일명), 제약조건명 수정; 민주
-- [190114] 회원 등급 삭제(fk컬럼, 테이블); 회의 결과
-- [190118] consult 테이블, consult_comment 테이블 컬럼추가 및 변경; 지예
-- [190120] reservation 테이블에 fk_idx_biz 컬럼 및 fk 제약조건 추가; 수미
-- [190122] pet_info 테이블에 pet_size, pet_weight 컬럼 not null 변경, pet_status 컬럼 추가; 현재
-- [190122] notification 테이블에 not_type 컬럼 check제약 조건 변경; 호환
-- [190124] 1; deposit 테이블에 fk_payment_UID 컬럼 추가; 수미
-- [190124] 2; notification 테이블에 컬럼 및 제약조건 추가 : 지민
-- [190125] 프로시저 where절 추가; 민주
-- [190126] 병원회원 최초 예약 스케줄 생성 프로시저 추가; 수미
-- [190128] 양방향 메세지, 시간 삭제;; 호환
-- [190129] 1; 예약 리스트에 필요한 view; 수미
-- [190129] 2; chart 테이블에 fk_reservation_UID 추가; 혜원
-- [190130] 오라클DB; notification 테이블 not_URL 컬럼 default값 변경;지민
-- [190131] 오라클DB; 반려동물체중 테이블, 시퀀스 추가 및 반려동물케어 컬럼 수정
-- [190205] review_comment 테이블 default 추가; 민주
-- [190206] review_comment 테이블 컬럼 추가; 민주
-- [190207] 맞춤추천에 필요한 function 생성; 고은
-- [190211] deposit테이블의 deposit_status 체크제약조건 수정;수미 / petcare 테이블에서 notification 테이블로 insert하는 프로시저;현재
-- [190213] notification 테이블의 not_date 컬럼 default값 sysdate 생성 ; 지민
------------------------------------------------------------------------------
-- 계정 조회
show user;

select *
from notification;

-- 모든 테이블 조회
select * from user_tables;

-- 모든 시퀀스 조회
select * from user_sequences;

-- 모든 제약조건 조회
select * from user_constraints;

-- 테이블 삭제 명령문
drop table member_level purge;
drop table member purge;
drop table login_log purge;
drop table biz_info purge;
drop table biz_info_img purge;
drop table recommend_tag purge;
drop table review_comment purge;
drop table reservation purge;
drop table pet_info purge;
drop table vaccine purge;
drop table shots purge;
drop table pet_list purge;
drop table petcare purge;
drop table caretype purge;
drop table chart purge;
drop table payment purge;
drop table deposit purge;
drop table refund purge;
drop table notification purge;
drop table withdraw purge;
drop table dep_use purge;
drop table prescription purge;
drop table video_advice purge;
drop table consult purge;
drop table consult_comment purge;
drop table petcare_img purge;
drop table board_group purge;
drop table board_post purge;
drop table board_comment purge;

drop table PETWEIGHT purge;
drop table RESERVATION purge;
drop table SCHEDULE purge;
drop table REVIEW purge;
drop table HAVE_TAG purge;
drop table RECOMMEND_TAG purge;
drop table DOCTORS purge;
drop table BIZ_INFO purge;
drop table MEMBER purge;

-- 시퀀스 삭제 명령문
drop sequence seq_member;
drop sequence biz_info_img_seq;
drop sequence seq_doctors_UID;
drop sequence seq_recommend_tag_UID;
drop sequence hava_tag;
drop sequence review;
drop sequence seq_review_UID;
drop sequence seq_rc_UID;
drop sequence seq_schedule_UID;
drop sequence seq_reservation_UID;
drop sequence seq_pet_info_UID;
drop sequence seq_vaccine_UID;
drop sequence seq_shots_UID;
drop sequence seq_petcare_UID;
drop sequence seq_caretype_UID;
drop sequence chart_seq;
drop sequence seq_payment_UID;
drop sequence seq_deposit_UID;
drop sequence seq_refund_refund_UID;
drop sequence seq_notification_UID;
drop sequence seq_withdraw_UID;
drop sequence seq_dep_use_UID;
drop sequence seq_prescription_UID;
drop sequence seq_video_advice_UID;
drop sequence seq_consult_UID;
drop sequence seq_consult_comment;
drop sequence petcare_img_seq;
drop sequence board_group_seq;
drop sequence seq_board_post;
drop sequence board_comment_seq;
drop sequence comment_seq;
drop sequence SEQ_PETWEIGHT_UID;

-------------------------------------------------------------------------------
--CREATE TABLE member_level (
--   level_UID      NUMBER   NOT NULL, -- 등급번호
--   level_name     VARCHAR2(20) NOT NULL, -- 등급명
--   level_limit    NUMBER   NOT NULL, -- 등급조건
--   level_contents VARCHAR2(100) NOT NULL  -- 등급설명
--    
--    ,CONSTRAINT PK_level PRIMARY KEY (level_UID)
--);
--
--drop table member_level purge;

-- 회원
CREATE TABLE member (
   idx          NUMBER    NOT NULL, -- 회원고유번호
   userid       VARCHAR2(255)  NOT NULL, -- 이메일아이디
   pwd          VARCHAR2(100)  NOT NULL, -- 비밀번호
   name         VARCHAR2(100)  NOT NULL, -- 이름
   nickname     VARCHAR2(100)  NOT NULL, -- 닉네임
   birthday     VARCHAR2(50)  NOT NULL, -- 생년월일
   gender       NUMBER(1) default 1 NOT NULL, -- 성별
   phone        VARCHAR2(100)  NOT NULL, -- 연락처
   profileimg   VARCHAR2(100)  NOT NULL, -- 프로필사진
   membertype   NUMBER(1) NOT NULL, -- 회원타입
   point        NUMBER    default 0 NOT NULL, -- 포인트
   totaldeposit NUMBER    default 0 NOT NULL, -- 누적예치금
   noshow       NUMBER    default 0 NOT NULL, -- 노쇼지수
   registerdate DATE      default sysdate NOT NULL  -- 가입일자
    
    , CONSTRAINT PK_member PRIMARY KEY (idx) -- 회원 기본키
    , CONSTRAINT uq_member_userid UNIQUE (userid) -- 회원아이디UQ   
    , CONSTRAINT ck_member_gender check(gender in(1,2)) -- 회원성별 체크제약   
    , CONSTRAINT ck_member_memtype check(membertype in(1, 2, 3)) -- 회원타입 체크제약
);

alter table member
add fileName   VARCHAR2(100)  NOT NULL;

-- 등급번호 삭제
ALTER TABLE member DROP COLUMN fk_level_UID;


CREATE TABLE login_log (
   idx           NUMBER   NOT NULL, -- 회원고유번호
   fk_userid     VARCHAR2(255) NOT NULL, -- 이메일아이디
   fk_pwd        VARCHAR2(100) NOT NULL, -- 비밀번호
   lastlogindate DATE     NOT NULL, -- 로그인일시
   member_status NUMBER(1)   default 1 NOT NULL  -- 회원상태 활동1 휴면0
    
    , CONSTRAINT PK_login_log PRIMARY KEY (idx) -- 로그인 기본키
    , CONSTRAINT CK_login_log_status check(member_status in(0,1)) -- 회원상태 체크제약
    , CONSTRAINT FK_member_TO_login_log FOREIGN KEY (idx) REFERENCES member (idx)
);

-- 회원 시퀀스
-- drop sequence seq_member;
create sequence seq_member
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 기업회원상세
CREATE TABLE biz_info (
   idx_biz    NUMBER    NOT NULL, -- 병원/약국고유번호
   biztype    NUMBER(1) NOT NULL, -- 기업구분
   repname    VARCHAR2(50)  NOT NULL, -- 대표자명
   biznumber  VARCHAR2(100)  NOT NULL, -- 사업자번호
   postcode   VARCHAR2(10)  NOT NULL, -- 우편번호
   addr1      VARCHAR2(100)  NOT NULL, -- 주소
   addr2      VARCHAR2(100)  NOT NULL, -- 주소2
   latitude   VARCHAR2(100)  NOT NULL, -- 위도
   longitude  VARCHAR2(100)  NOT NULL, -- 경도
   prontimg   VARCHAR2(100)  NOT NULL, -- 대표이미지
   weekday    VARCHAR2(100)  NOT NULL, -- 평일; 월~금(주 5), 화~금(주 4), 월, 수, 금(주 3)
   wdstart    DATE      NOT NULL, -- 평일시작시간
   wdend      DATE      NOT NULL, -- 평일종료시간
   lunchstart DATE      NOT NULL, -- 점심시작시간
   lunchend   DATE      NOT NULL, -- 점심종료시간
   satstart  DATE      NOT NULL, -- 토요일시작
   satend     DATE      NOT NULL, -- 토요일종료
   dayoff     VARCHAR2(100)  NOT NULL, -- 일요일/공휴일
   dog        NUMBER(1) NOT NULL, -- 강아지
   cat        NUMBER(1) NOT NULL, -- 고양이
   smallani   NUMBER(1) NOT NULL, -- 소동물
   etc        NUMBER(1) NOT NULL, -- 기타
   easyway  VARCHAR2(255)  NULL,     -- 찾아오는길
   intro      CLOB      NOT NULL  -- 소개글
    ,CONSTRAINT PK_biz_info -- 기업회원상세 기본키
      PRIMARY KEY (
         idx_biz -- 병원/약국고유번호
      )
    ,CONSTRAINT UK_biz_info -- 기업회원상세 유니크 제약
      UNIQUE (
         biznumber -- 사업자번호
      )
    ,CONSTRAINT ck_biz_info_dog -- 강아지 체크제약
      check(dog in(1,0))
    ,CONSTRAINT ck_biz_info_cat -- 고양이 체크제약
      check(cat in(1,0))
    ,CONSTRAINT ck_biz_info_smallani -- 소동물 체크제약
      check(smallani in(1,0))
    ,CONSTRAINT ck_biz_info_etc -- 기타 체크제약
      check(etc in(1,0))
    ,CONSTRAINT FK_member_TO_biz_info -- 회원 -> 기업회원상세
      FOREIGN KEY (
         idx_biz -- 병원/약국고유번호
      )
      REFERENCES member ( -- 회원
         idx -- 회원고유번호
      )
);


-- 기업회원추가이미지
CREATE TABLE biz_info_img (
   img_UID     NUMBER   NOT NULL, -- 이미지고유번호
   fk_idx_biz  NUMBER   NOT NULL, -- 병원/약국고유번호
   imgfilename VARCHAR2(100) NOT NULL  -- 이미지파일명
    ,CONSTRAINT PK_biz_info_img -- 기업회원추가이미지 기본키
      PRIMARY KEY (
         img_UID -- 이미지고유번호
      )
);
ALTER TABLE biz_info_img
   ADD
      CONSTRAINT FK_biz_info_TO_biz_info_img -- 기업회원상세 -> 기업회원추가이미지
      FOREIGN KEY (
         fk_idx_biz -- 병원/약국고유번호
      )
      REFERENCES biz_info ( -- 기업회원상세
         idx_biz -- 병원/약국고유번호
      );


create sequence biz_info_img_seq --기업정보 이미지 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 의료진
CREATE TABLE doctors (
	doc_UID    NUMBER    NOT NULL, -- 의료진고유번호
	fk_idx_biz NUMBER    NOT NULL, -- 병원/약국고유번호
	docname    VARCHAR2(100)  NOT NULL, -- 의료진명
	dog        NUMBER(1) NOT NULL, -- 강아지
	cat        NUMBER(1) NOT NULL, -- 고양이
	smallani   NUMBER(1) NOT NULL, -- 소동물
	etc        NUMBER(1) NOT NULL  -- 기타
    ,CONSTRAINT PK_doctors -- 의료진 기본키
		PRIMARY KEY (
			doc_UID -- 의료진고유번호
		)
     ,CONSTRAINT ck_doctors_dog -- 강아지 체크제약
		check(dog in(1,0))
    ,CONSTRAINT ck_doctors_cat -- 고양이 체크제약
		check(cat in(1,0))
    ,CONSTRAINT ck_doctors_smallani -- 소동물 체크제약
		check(smallani in(1,0))
    ,CONSTRAINT ck_doctors_etc -- 기타 체크제약
		check(etc in(1,0))
);

create sequence seq_doctors_UID --의료진 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 태그 테이블
--drop table recommend_tag purge;
CREATE TABLE recommend_tag (
   tag_UID  NUMBER   NOT NULL, -- 태그번호
   tag_type VARCHAR2(100) NOT NULL, -- 분야
   tag_name VARCHAR2(100) NOT NULL  -- 태그이름
    ,CONSTRAINT PK_recommend_tag PRIMARY KEY(tag_UID)
);

ALTER TABLE recommend_tag 
ADD CONSTRAINT UQ_recommend_tag_name UNIQUE(tag_name);

-- 태그 시퀀스
create sequence seq_recommend_tag_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 태그 insert
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '깨끗함');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '세련됨');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '동물친화적');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '대형병원');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '종합병원');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '편안한');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '무선인터넷');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시설상태', '주차');

insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '서비스', '친절한');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '서비스', '세심한');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '서비스', '잘봐주는');

insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '가격', '가성비');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '가격', '가심비');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '가격', '프리미엄');

insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '슬개골전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '노령전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '중성화수술전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '심장전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '재활전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '한방전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '안과전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '암전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '치아전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '강아지전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '고양이전문');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '전문분야', '소동물전문');

insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시간', '야간');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시간', '주말');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시간', '24시간');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '시간', '공휴일');

insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '호텔');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '간식');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '용품');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '미용');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '분양');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '동물카페');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '훈련');
insert into recommend_tag(tag_UID, tag_type, tag_name) values(seq_recommend_tag_UID.nextval, '편의시설', '건강검진센터');

commit;

-- 병원 또는 일반 회원 보유 태그
drop table have_tag purge;
CREATE TABLE have_tag (
    fk_tag_UID  NUMBER   NOT NULL, -- 태그번호
    fk_tag_name VARCHAR2(100) NOT NULL,  -- 태그이름
    fk_idx      NUMBER   NOT NULL -- 회원고유번호
);

ALTER TABLE have_tag 
ADD CONSTRAINT FK_have_tag_UID FOREIGN KEY(fk_tag_UID) 
REFERENCES recommend_tag(tag_UID);

ALTER TABLE have_tag 
ADD CONSTRAINT FK_have_tag_name FOREIGN KEY(fk_tag_name) 
REFERENCES recommend_tag(tag_name);

ALTER TABLE have_tag 
ADD CONSTRAINT FK_have_tag_ide FOREIGN KEY(fk_idx) 
REFERENCES member(idx);

-- 리뷰
CREATE TABLE review (
	review_UID         NUMBER   NOT NULL, -- 리뷰코드
	fk_idx_biz         NUMBER   NOT NULL, -- 병원/약국고유번호
	fk_idx             NUMBER   NOT NULL, -- 회원고유번호
	fk_reservation_UID NUMBER   NOT NULL, -- 예약코드
	startpoint         NUMBER   NOT NULL, -- 평점
	fk_userid          VARCHAR2(255) NOT NULL, -- 작성자아이디
	fk_nickname        VARCHAR2(100) NOT NULL, -- 작성자닉네임
	rv_contents        CLOB     NOT NULL, -- 한줄리뷰내용
	rv_status          NUMBER(1) default 1  NOT NULL, -- 리뷰상태
	rv_blind           NUMBER(1) default 0 NOT NULL, -- 리뷰블라인드사유 0 없음 1 욕설 2 기업회원요청 3 신고누적 4 기타
	rv_writeDate       date     default sysdate NOT NULL  -- 리뷰날짜
    ,CONSTRAINT PK_review PRIMARY KEY (review_UID)
    ,CONSTRAINT ck_review_status -- 리뷰상태 체크제약
		check(rv_status in(0,1))
    ,CONSTRAINT ck_review_blind -- 리뷰블라인드사유 체크제약
		check(rv_blind in(0,1,2,3,4))
);

-- 리뷰 시퀀스
create sequence seq_review_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


-- 리뷰댓글(reviewComment)
CREATE TABLE review_comment (
	rc_id         NUMBER    NOT NULL, -- 리뷰댓글번호
	fk_review_UID NUMBER    NOT NULL, -- 리뷰코드
	fk_idx        NUMBER    NOT NULL, -- 회원고유번호
	rc_content    CLOB      NOT NULL, -- 댓글내용
	rc_writedate  DATE      NOT NULL, -- 댓글날짜
	fk_rc_id      NUMBER    NOT NULL, -- 원댓글 고유번호
	rc_group      NUMBER    NOT NULL, -- 댓글그룹번호
	rc_g_odr      NUMBER    NOT NULL, -- 댓글그룹순서
	rc_depth      NUMBER    NOT NULL, -- 계층
	rc_blind      NUMBER(1)   NOT NULL, -- 블라인드처리이유 0 없음 1 욕설 2 기업회원요청 3 신고누적 4 기타
	rc_status     NUMBER(1) NULL,      -- 상태
    CONSTRAINT PK_review_comment PRIMARY KEY(rc_id)
    ,CONSTRAINT ck_rc_status -- 리뷰댓글상태 체크제약
		check(rc_status in(0,1))
    ,CONSTRAINT ck_rc_blind -- 블라인드처리이유 체크제약
		check(rc_blind in(0,1,2,3,4)) 
);

-- [190205] review_comment 테이블 default 추가; 민주
alter table review_comment
modify rc_group default 0;

alter table review_comment
modify rc_g_odr default 0;

alter table review_comment
modify rc_depth default 0;

-- [190206] review_comment 테이블 컬럼 추가; 민주
alter table review_comment
add rc_userid varchar2(255) not null;

alter table review_comment
add rc_nickname varchar2(100) not null;

-- 리뷰 댓글 시퀀스
create sequence seq_rc_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 스케쥴
CREATE TABLE schedule (
	schedule_UID    NUMBER    NOT NULL, -- 스케쥴코드
	fk_idx_biz      NUMBER    NOT NULL, -- 병원/약국고유번호
	schedule_DATE   DATE      NOT NULL, -- 예약일정
	schedule_status NUMBER(1) default 0 NOT NULL  -- 일정상태 예약: 1/ 비예약: 0/default: 0
    ,CONSTRAINT PK_schedule -- 스케쥴 기본키
		PRIMARY KEY (schedule_UID)
    ,CONSTRAINT ck_sch_status -- 일정상태 체크제약
		check(schedule_status in(1,0))
    ,CONSTRAINT fk_sch_idx_biz -- 기업회원상세 -> 스케쥴
		FOREIGN KEY (fk_idx_biz)	REFERENCES biz_info(idx_biz)
);

-- 스케쥴               
create sequence seq_schedule_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;   

-- 예약
CREATE TABLE reservation (
	reservation_UID    NUMBER    NOT NULL, -- 예약코드
	fk_idx             NUMBER    NOT NULL, -- 회원고유번호
	fk_schedule_UID    NUMBER    NOT NULL, -- 스케쥴코드
	fk_pet_UID         NUMBER    NOT NULL, -- 반려동물코드
	bookingdate        DATE      default sysdate NOT NULL, -- 예약완료일시
	reservation_DATE   DATE      NOT NULL, -- 방문예정일
	reservation_status NUMBER(1) NOT NULL, -- 예약진행상태 1 예약완료/ 2 결제완료 / 3 진료완료 / 4 취소 / 5 no show
	reservation_type   NUMBER    NOT NULL  -- 예약타입 1 진료 / 2 예방접종 / 3 수술/ 4 호텔링
    
    ,CONSTRAINT PK_reservation -- 예약 기본키
		PRIMARY KEY (reservation_UID)
    ,CONSTRAINT ck_rev_status -- 예약진행상태 체크제약
		check(reservation_status in(1,2,3,4,5))
    ,CONSTRAINT ck_rev_type -- 예약타입 체크제약
		check(reservation_type in(1, 2, 3, 4))
    ,CONSTRAINT FK_member_TO_reservation -- 회원 -> 예약
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		)
    ,CONSTRAINT FK_schedule_TO_reservation -- 스케쥴 -> 예약
		FOREIGN KEY (
			fk_schedule_UID -- 스케쥴코드
		)
		REFERENCES schedule ( -- 스케쥴
			schedule_UID -- 스케쥴코드
		)
);

-- 예약   
create sequence seq_reservation_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

alter table reservation add fk_idx_biz NUMBER not null;
alter table reservation add constraint fk_reservation_idx_biz FOREIGN KEY (fk_idx_biz) REFERENCES biz_info(idx_biz);
                
-- *** 반려동물정보
-- drop table pet_info purge;
CREATE TABLE pet_info (
pet_UID          NUMBER        NOT NULL                     -- 반려동물코드
,fk_idx          NUMBER        NOT NULL                     -- 회원고유번호
,pet_name        VARCHAR2(100) NOT NULL                     -- 반려동물이름
,pet_type        VARCHAR2(50)  NOT NULL                     -- 종류 dog/cat/smallani/etc
,pet_birthday    VARCHAR2(100) NULL                         -- 반려동물생일  
,pet_size        VARCHAR2(1)   NOT NULL                     -- 사이즈 L/M/S
,pet_weight      NUMBER        NOT NULL                     -- 몸무게  
/*	
    [19-01-22] from NULL to NOT NULL -->   
    ,pet_size        VARCHAR2(2)   NULL
    ,pet_weight      NUMBER        NULL
*/    
,pet_gender      VARCHAR2(1)   NULL                         -- 성별 1 남 2 여
,pet_neutral     VARCHAR2(1)   NULL                         -- 중성화여부  0 안함 / 1 함 / 2 모름
,medical_history CLOB          NULL                         -- 과거병력기재
,allergy         CLOB          NULL                         -- 알러지내역
,pet_profileimg  VARCHAR2(255) NULL                         -- 반려동물프로필사진
/*	[19-01-22] 반려동물상태 컬럼 추가 */
,pet_status      VARCHAR2(1)   DEFAULT 1 NOT NULL           -- 반려동물상태 0 무지개다리 / 1 생존 / 2 입원
,CONSTRAINT PK_pet_info PRIMARY KEY (pet_UID)               -- 반려동물정보 기본키
,CONSTRAINT FK_member_TO_pet_info FOREIGN KEY (fk_idx)      -- 회원 -> 반려동물정보
                                    REFERENCES member (idx)
,CONSTRAINT ck_petinfo_gender check(pet_gender in(1,2))     -- 반려동물성별 체크제약
,CONSTRAINT ck_petinfo_neutral check(pet_neutral in(0,1,2)) -- 중성화여부 체크제약	 
);
/*	
    [19-01-22] 반려동물상태 컬럼 추가 
    alter table pet_info
    add pet_status VARCHAR2(1) DEFAULT 1 NOT NULL;
*/

-- drop sequence seq_pet_info_UID;
create sequence seq_pet_info_UID 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- *** 케어타입
-- drop table caretype purge;
CREATE TABLE caretype (
caretype_UID   NUMBER        NOT NULL             -- 케어타입코드
,caretype_name VARCHAR2(100) NOT NULL             -- 케어타입명
,caretype_info CLOB          NOT NULL             -- 케어타입별설명
,CONSTRAINT PK_caretype PRIMARY KEY(caretype_UID) -- 케어타입 기본키
);

-- drop sequence seq_caretype_UID
create sequence seq_caretype_UID 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 케어타입 insert
insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '식사', '<p>각 항목 작성 안내사항<br/></br>[식사의 경우]<br/>블라블라</p>');

insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '용변', '<p>각 항목 작성 안내사항<br/></br>[용변 경우]<br/>블라블라</p>');

insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '양치', '<p>각 항목 작성 안내사항<br/></br>[양치 경우]<br/>블라블라</p>');

insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '목욕', '<p>각 항목 작성 안내사항<br/></br>[목욕 경우]<br/>블라블라</p>');

insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '달력', '<p>각 항목 작성 안내사항<br/></br>[목욕 경우]<br/>블라블라</p>');

insert into caretype(caretype_UID, caretype_name, caretype_info)
values(seq_caretype_UID.nextval, '메모', '<p>각 항목 작성 안내사항<br/></br>[목욕 경우]<br/>블라블라</p>');

commit;

-- *** 반려동물케어
-- drop table petcare purge;
CREATE TABLE petcare (
care_UID         NUMBER         NOT NULL -- 케어코드
,fk_pet_UID      NUMBER         NOT NULL -- 반려동물코드
,fk_caretype_UID NUMBER         NOT NULL -- 케어타입코드
,care_contents   CLOB           NOT NULL -- 내용
,care_memo       CLOB           NULL     -- 메모
,care_start      varchar2(100)  NOT NULL -- 시작일시
,care_end        varchar2(100)  NOT NULL -- 종료일시
,care_alarm      NUMBER(10)     NULL     -- 알림여부 없음 0/5분전 5/10분전 10/하루전 1440 (분 단위 환산)
,care_date       varchar2(100)  NOT NULL -- 케어등록 일자
,CONSTRAINT PK_petcare PRIMARY KEY (care_UID) -- 반려동물케어 기본키
,CONSTRAINT FK_pet_info_TO_petcare FOREIGN KEY (fk_pet_UID) 
                                    REFERENCES pet_info (pet_UID) -- 반려동물정보 -> 반려동물케어
,CONSTRAINT FK_caretype_TO_petcare FOREIGN KEY (fk_caretype_UID) 
                                    REFERENCES caretype (caretype_UID) -- 반려동물케어 -> 케어타입
);
/*	
    [19-01-31] 반려동물케어 컬럼 수정 
    ALTER TABLE petcare MODIFY(care_start varchar2(100));
    ALTER TABLE petcare MODIFY(care_end varchar2(100));
    ALTER TABLE petcare MODIFY(care_date varchar2(100));
*/
 
-- drop sequence seq_petcare_UID
create sequence seq_petcare_UID  --펫케어
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

/*	[19-01-31] 반려동물체중 테이블, 시퀀스 추가 */
-- *** 반려동물체중
-- drop table petweight purge;
create table petweight
(petweight_UID      NUMBER  NOT NULL    -- 반려동물 몸무게 코드
,fk_pet_UID         NUMBER  NOT NULL    -- 반려동물코드
,petweight_past     NUMBER  NOT NULL    -- 반려동물 몸무게
,petweight_targeted NUMBER              -- 반려동물 목표 몸무게d
,petweight_date     DATE    NOT NULL    -- 등록일자
);
/*	
    [19-02-11] 반려동물 목표체중 컬럼 추가 
    alter table petweight
    add petweight_targeted NUMBER;
*/

-- drop sequence seq_petweight_UID
create sequence seq_petweight_UID 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle;

-- 백신
--CREATE TABLE vaccine (
--	vaccine_UID  NUMBER    NOT NULL, -- 백신코드
--	vaccine_name VARCHAR2(100)  NOT NULL, -- 백신명
--	dog          NUMBER(1) NOT NULL, -- 강아지
--	cat          NUMBER(1) NOT NULL, -- 고양이
--	smallani     NUMBER(1) NOT NULL  -- 소동물
--    ,CONSTRAINT PK_vaccine -- 백신 기본키
--		PRIMARY KEY (vaccine_UID)
--    ,CONSTRAINT ck_vaccine_dog -- 강아지 체크제약
--		check(dog in(1,0))
--    ,CONSTRAINT ck_vaccine_cat -- 고양이 체크제약
--		check(cat in(1,0))
--    ,CONSTRAINT ck_vaccine_smallani -- 소동물 체크제약
--		check(smallani in(1,0))
--);
--
--create sequence seq_vaccine_UID  --백신
--start with 1
--increment by 1
--nomaxvalue
--nominvalue
--nocycle
--nocache;

-- 접종내용
--CREATE TABLE shots (
--	shots_UID      NUMBER   NOT NULL, -- 접종코드
--	fk_pet_UID     NUMBER   NOT NULL, -- 반려동물코드
--	fk_vaccine_UID NUMBER   NOT NULL, -- 백신코드
--	vaccine_name   VARCHAR2(100) NOT NULL  -- 백신명
--    ,CONSTRAINT PK_shots -- 접종내용 기본키
--		PRIMARY KEY (shots_UID)
--);
--        
--create sequence seq_shots_UID  --접종
--start with 1
--increment by 1
--nomaxvalue
--nominvalue
--nocycle
--nocache;

select fk_idx_biz from reservation group by fk_idx_biz;

-- 진료기록
CREATE TABLE chart (
	chart_UID        NUMBER   NOT NULL, -- 차트코드
	fk_pet_UID       NUMBER   NOT NULL, -- 반려동물코드
	fk_idx           NUMBER   NOT NULL, -- 회원고유번호
	chart_type       NUMBER(1) NOT NULL, -- 진료타입  0 약국/1 진료 / 2 예방접종 / 3 수술 / 4 호텔링
	biz_name         VARCHAR2(100) NOT NULL, -- 병원/약국명
	bookingdate      DATE     NULL,     -- 예약완료일시
	reservation_DATE DATE     NULL,     -- 방문예정일
	doc_name         VARCHAR2(100) NULL,     -- 수의사명
	cautions         CLOB     NULL,     -- 주의사항
	chart_contents   CLOB     NULL,     -- 내용
	payment_pay      NUMBER   NULL,     -- 사용예치금
	payment_point    NUMBER   NULL,     -- 사용포인트
	addpay           NUMBER   NULL,     -- 본인부담금(추가결제금액)
	totalpay         NUMBER   NULL,      -- 진료비총액
    fk_reservation_UID NUMBER NULL     -- 예약코드 [190129]
    ,CONSTRAINT PK_chart -- 진료기록 기본키
		PRIMARY KEY (chart_UID)
    ,CONSTRAINT ck_chart_type -- 진료타입 체크제약
		check(chart_type in(0,1,2,3,4))
);

create sequence chart_seq --차트
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- [190129] chart 테이블에 fk_reservation_UID 추가
alter table chart
add fk_reservation_UID NUMBER NULL;


-- 예치금결제
CREATE TABLE payment (
	payment_UID        NUMBER NOT NULL, -- 결제코드
	fk_reservation_UID NUMBER NOT NULL, -- 예약코드
	payment_total      NUMBER NOT NULL, -- 결제총액
	payment_point      NUMBER NOT NULL, -- 결제포인트
	payment_pay        NUMBER NOT NULL, -- 실결제금액
	payment_date       DATE   NOT NULL, -- 결제일자
	payment_status     NUMBER(1) NOT NULL  -- 결제상태 1 결제완료 / 0 미결제 / 2 취소 / 3 환불
    ,CONSTRAINT PK_payment PRIMARY KEY (payment_UID)
    ,CONSTRAINT CK_payment_status -- 결제상태 체크제약
		check(payment_status in(0,1,2,3))
);

-- 예치금결제 
create sequence seq_payment_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache; 

-- 예치금
CREATE TABLE deposit (
	deposit_UID    NUMBER   NOT NULL, -- 예치금코드
	fk_idx         NUMBER   NOT NULL, -- 회원고유번호
	depositcoin    NUMBER   NOT NULL, -- 예치금
	deposit_status NUMBER(1)   default 1 NOT NULL, -- 예치금상태 1 사용가능 / 0 사용불가능 / 2 환불취소신청 / 3 출금
	deposit_type   VARCHAR2(50) NOT NULL, -- 충전수단
	deposit_date   DATE     default sysdate NOT NULL,  -- 충전일자
    FK_PAYMENT_UID number default 0 not null -- 결제번호
    ,CONSTRAINT PK_deposit -- 예치금 기본키
		PRIMARY KEY (deposit_UID)
    ,CONSTRAINT CK_deposit_status -- 예치금상태 체크제약
		check(deposit_status in(0,1,2,3))
);

-- 190124
alter table deposit
add FK_PAYMENT_UID NUMBER DEFAULT 0 NOT NULL;

-- 190211; deposit테이블의 deposit_status 체크제약조건 수정
alter table deposit
drop CONSTRAINT CK_deposit_status;

alter table deposit
add CONSTRAINT CK_deposit_status check(deposit_status in(0,1,2,3, -1));

-- 예치금 
create sequence seq_deposit_UID
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache; 

-- 환불
--CREATE TABLE refund (
--	refund_UID     NUMBER NOT NULL, -- 환불코드
--	fk_payment_UID NUMBER   NOT NULL, -- 결제코드
--	fk_idx         NUMBER   NOT NULL, -- 환불받을회원번호
--	fk_idx_biz     NUMBER   NOT NULL, -- 병원번호
--	refund_DATE    DATE     default sysdate NOT NULL, -- 환불신청일자
--	add_DATE       DATE     NOT NULL, -- 사용일자
--	refund_reason  VARCHAR2(255) NOT NULL, -- 환불사유
--	refund_money   NUMBER   NOT NULL, -- 환불금액
--	refund_status  NUMBER(1)   default 0 NOT NULL  -- 승인여부 1확인 0미확인
--    ,CONSTRAINT PK_refund -- 환불 기본키
--		PRIMARY KEY (refund_UID)
--    ,CONSTRAINT CK_refund_status -- 승인여부 체크제약
--		check(refund_status in(0,1))
--);
--
---- 환불 
--create sequence seq_refund_refund_UID
--start with 1
--increment by 1
--nomaxvalue
--nominvalue
--nocycle
--nocache; 

select *
from notification;

-- 알림
CREATE TABLE notification (
	not_UID       NUMBER   NOT NULL, -- 알림코드
	fk_idx        NUMBER   NOT NULL, -- 회원고유번호
	not_type     NUMBER(1) NOT NULL, -- 알림유형  0 전체공지 / 1 petcare / 2 reservation / 3 payment / 4 board / 5 화상채팅
	not_message   CLOB     NOT NULL, -- 알림내용
	not_date      DATE     NOT NULL, -- 알림발송일시
	not_readcheck NUMBER(1)   default 0 NOT NULL  -- 확인여부 확인 1 / 미확인 0
    ,CONSTRAINT PK_notification -- 알림 기본키
		PRIMARY KEY (not_UID)
    ,CONSTRAINT CK_not_type -- 알림유형 체크제약
		check(not_type in(0,1,2,3,4))
    ,CONSTRAINT CK_not_readcheck -- 확인여부 체크제약
		check(not_readcheck in(0,1))
);

alter table notification drop constraint CK_not_type;

alter table notification
add constraint CK_not_type check (not_type in(0,1,2,3,4,5));

alter table notification
add not_remindstatus NUMBER(1) default 0 NOT NULL; -- 재알림 여부

alter table notification
add CONSTRAINT CK_not_remindstatus  check(not_remindstatus in (0,1)); -- 재알람 여부 제약조건추가

alter table notification
add not_time DATE default sysdate NOT NULL; -- 예약알림 예정시간

alter table notification
add not_URL VARCHAR2(200) default 'http://localhost:9090/petopia/notificationList.pet' NOT NULL; -- 이동url

-- 190130
alter table notification
modify not_URL 'http://localhost:9090/petopia/notificationList.pet';

-- 190213
alter table notification
modify NOT_DATE default sysdate;

create sequence seq_notification_UID --알람
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 예치금출금
--CREATE TABLE withdraw (
--	withdraw_UID    NUMBER NOT NULL, -- 출금코드
--	fk_deposit_UID  NUMBER NOT NULL, -- 예치금코드
--	withdraw_money  NUMBER NOT NULL, -- 출금요청금액
--	withdraw_status NUMBER(1) default 0 NOT NULL  -- 출금상태 1 완료 / 0 대기
--    ,CONSTRAINT PK_withdraw -- 예치금출금 기본키
--		PRIMARY KEY (withdraw_UID)
--    ,CONSTRAINT CK_withdraw_status -- 출금상태 체크제약
--		check(withdraw_status in(0,1))
--);
--
---- 예치금출금 
--create sequence seq_withdraw_UID
--start with 1
--increment by 1
--nomaxvalue
--nominvalue
--nocycle
--nocache; 

-- 예치금 사용내역
--CREATE TABLE dep_use (
--	dep_use_UID        NUMBER NOT NULL, -- 사용내역코드
--	fk_deposit_UID     NUMBER NOT NULL,     -- 예치금코드
--	fk_payment_UID     NUMBER NOT NULL,     -- 결제코드
--	fk_reservation_UID NUMBER NOT NULL,     -- 예약코드
--	depu_money         NUMBER NOT NULL,     -- 사용금액
--	deposit_usedate    DATE   default sysdate NOT NULL  -- 사용일자
--    ,CONSTRAINT PK_dep_use -- 예치금 사용내역 기본키
--		PRIMARY KEY (dep_use_UID)
--);
--
---- 사용내역 
--create sequence seq_dep_use_UID
--start with 1
--increment by 1
--nomaxvalue
--nominvalue
--nocycle
--nocache; 

-- 처방전
CREATE TABLE prescription (
	rx_UID      number       NOT NULL, -- 처방코드
	chart_UID   NUMBER       NOT NULL, -- 차트코드
	rx_name     varchar2(100) NOT NULL, -- 처방약
	dose_number varchar2(100) NULL,     -- 복용횟수
	dosage      varchar2(100) NULL,     -- 복용용량
	rx_notice   CLOB         NULL,     -- 처방안내
	rx_cautions varchar2(100) NULL,     -- 주의사항
	rx_regName  varchar2(100) NOT NULL  -- 등록한사람
    ,CONSTRAINT PK_prescription -- 처방전 기본키
		PRIMARY KEY (rx_UID)
);

create sequence seq_prescription_UID --처방
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select *
from video_advice;

-- 화상 상담(video advice)
CREATE TABLE video_advice (
	va_UID      NUMBER       NOT NULL, -- 화상상담 번호
	fk_idx      NUMBER       NOT NULL, -- 회원고유번호
	fk_idx_biz  NUMBER       NOT NULL, -- 병원/약국고유번호
	chatcode    VARCHAR2(20) NOT NULL, -- 채팅방 코드
	fk_userid   VARCHAR2(255)     NOT NULL, -- 회원아이디
	fk_name_biz VARCHAR2(100)     NOT NULL, -- 병원명
	fk_docname  VARCHAR2(100)     NOT NULL, -- 수의사명
	usermessage CLOB         NULL, -- 회원이 보낸 메세지
	docmessage  CLOB         NULL, -- 수의사가 보낸 메세지
	umtime      DATE NULL, -- 회원이 메세지보낸 시각
	dmtime      DATE NULL,  -- 수의사가 메세지보낸 시각
    startTime date default sysdate NOT NULL,  -- 화상채팅 시작시간
    endTime  date  NULL  -- 화상채팅 종료시간

    ,CONSTRAINT PK_video_advice -- 화상 상담(video advice) 기본키
		PRIMARY KEY (va_UID)
);
-- [190128] 오라클DB; 시간, 메세지 삭제 Video_advice; 호환
alter table video_advice drop column usermessage;
alter table video_advice drop column docmessage;
alter table video_advice drop column umtime;
alter table video_advice drop column dmtime;
alter table video_advice drop column endTime;

alter table video_advice rename column startTime to Time;

commit;

create sequence seq_video_advice_UID  --화상상담
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


-- 1:1상담
CREATE TABLE consult (
	consult_UID NUMBER   NOT NULL, -- 상담코드
	fk_idx      NUMBER   NOT NULL, -- 회원고유번호
	cs_pet_type NUMBER(1) NOT NULL, -- 동물분류 1 강아지 / 2 고양이 / 3 소동물 / 4 기타
	cs_title    VARCHAR2(100) NOT NULL, -- 상담제목
	cs_contents CLOB     NOT NULL, -- 상담내용
	cs_hit      NUMBER   NOT NULL, -- 조회수
	cs_writeday DATE     NOT NULL, -- 작성일자
	cs_secret   NUMBER(1)   NOT NULL  -- 공개여부 0 비공개 / 1 공개
    ,CONSTRAINT PK_consult -- 1:1상담 기본키
		PRIMARY KEY (consult_UID)
    ,CONSTRAINT ck_consult_type -- 동물분류 체크제약
		check(cs_pet_type in(1,2,3,4))
    ,CONSTRAINT ck_cs_secret -- 공개여부 체크제약
		check(cs_secret in(0,1))
);
  
create sequence seq_consult_UID --1:1 상담
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

alter table consult
modify cs_writeday default sysdate;
alter table consult
modify cs_hit default 0;
alter table consult
add commentCount VARCHAR2(100) default 0 NOT NULL;

-- 1:1상담 댓글
CREATE TABLE consult_comment (
	cmt_id         NUMBER   NOT NULL, -- 댓글고유번호
	fk_consult_UID NUMBER   NOT NULL, -- 상담코드
	fk_idx         NUMBER   NOT NULL, -- 댓글회원고유번호
	cscmt_nickname VARCHAR2(100) NOT NULL, -- 댓글작성자
	cscmt_contents CLOB     NOT NULL, -- 댓글내용
	cscmt_writeday DATE     NOT NULL, -- 댓글작성일시
	fk_cmt_id      NUMBER   NOT NULL, -- 원댓글 고유번호
	cscmt_group    NUMBER default 0  NOT NULL, -- 댓글그룹번호
	cscmt_g_odr    NUMBER   default 0 NOT NULL, -- 댓글그룹순서
	cscmt_depth    NUMBER   default 0 NOT NULL, -- 계층
	cscmt_del      NUMBER(1)   default 1 NOT NULL  -- 삭제여부 0삭제 / 1 사용가능
    ,CONSTRAINT PK_consult_comment PRIMARY KEY (cmt_id)
    ,CONSTRAINT ck_cscmt_del -- 삭제여부 체크제약
		check(cscmt_del in(1,0))
);

create sequence seq_consult_comment  --1:1 상담 댓글
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

alter table consult_comment
modify cscmt_writeday default sysdate;

-- 펫케어 이미지
CREATE TABLE petcare_img (
	pc_img_UID  NUMBER   NOT NULL, -- 이미지번호
	fk_care_UID NUMBER   NOT NULL, -- 케어코드
	pc_img_name VARCHAR2(255) NOT NULL  -- 이미지명
    ,CONSTRAINT PK_petcare_img -- 펫케어 이미지 기본키
		PRIMARY KEY (pc_img_UID)
);

create sequence petcare_img_seq  --펫케어 이미지
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 게시판그룹
CREATE TABLE board_group (
	brd_id    NUMBER   NOT NULL, -- 게시판그룹코드
	brd_name  VARCHAR2(20) NOT NULL, -- 게시판명
	brd_grant NUMBER(1)   NOT NULL  -- 글쓰기권한 (1, 2, 3)
    ,CONSTRAINT PK_board_group -- 게시판그룹 기본키
		PRIMARY KEY (brd_id)
    ,CONSTRAINT ck_brd_grant -- 글쓰기권한 체크제약
		check(brd_grant in(1,2,3))
);
        
create sequence board_group_seq --게시판 그룹
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 게시글
CREATE TABLE board_post (
	post_id          NUMBER   NOT NULL, -- 게시글고유번호
	fk_brd_id        NUMBER   NOT NULL, -- 게시판그룹코드
	post_title       VARCHAR2(100) NOT NULL, -- 게시글제목
	post_contents    CLOB     NOT NULL, -- 게시글내용
	fk_idx           NUMBER   NOT NULL, -- 작성자고유번호
	fk_nickname      VARCHAR2(100) NOT NULL, -- 작성자
	post_writeday    DATE     NOT NULL, -- 작성일
	post_hit         NUMBER   NOT NULL, -- 조회수
	post_del         NUMBER(1)   NOT NULL, -- 삭제여부
	post_repcnt      NUMBER   NOT NULL, -- 댓글수
	post_imgfilename VARCHAR2(255) NULL      -- 대표이미지
    ,CONSTRAINT PK_board_post -- 게시글 기본키
		PRIMARY KEY (post_id)
    ,CONSTRAINT ck_post_del -- 삭제여부 체크제약
		check(post_del in(0,1))
);
        
create sequence seq_board_post --게시글
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 댓글
CREATE TABLE board_comment (
	cmt_id       NUMBER   NOT NULL, -- 댓글고유번호
	fk_brd_id    NUMBER   NOT NULL, -- 게시판그룹코드
	fk_post_id   NUMBER   NOT NULL, -- 게시글고유번호
	fk_idx       NUMBER   NOT NULL, -- 댓글작성자고유번호
	fk_nickname  VARCHAR2(100) NOT NULL, -- 댓글작성자
	cmt_contents CLOB     NOT NULL, -- 댓글내용
	cmt_writeday DATE     NOT NULL, -- 댓글작성일시
	cmt_group    NUMBER   NOT NULL, -- 댓글그룹번호
	cmt_g_odr    NUMBER   NOT NULL, -- 댓글그룹순서
	cmt_depth    NUMBER   NOT NULL, -- 계층
	cmt_del      NUMBER(1)   NOT NULL  -- 삭제여부
    ,CONSTRAINT PK_comment PRIMARY KEY (cmt_id)
    ,CONSTRAINT ck_cmt_del -- 삭제여부 체크제약
		check(cmt_del in(0,1))
);
        
create sequence board_comment_seq --댓글
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


---- 이벤트
--CREATE TABLE event (
--	ev_id          NUMBER   NOT NULL, -- 이벤트코드
--	ev_title       VARCHAR2(255) NOT NULL, -- 이벤트제목
--	ev_contents    CLOB     NOT NULL, -- 이벤트내용
--	ev_imgfilename VARCHAR2(255) NOT NULL, -- 이벤트배너
--	ev_start       DATE     NOT NULL, -- 이벤트시작
--	ev_end         DATE     NOT NULL  -- 이벤트종료
--    ,CONSTRAINT PK_event -- 이벤트 기본키
--		PRIMARY KEY (ev_id)
--);
--
---- 유기동물후원
--CREATE TABLE funding (
--	fd_id          NUMBER   NOT NULL, -- 후원코드
--	fd_title       VARCHAR2 NOT NULL, -- 후원제목
--	fd_orgname     VARCHAR2 NOT NULL, -- 단체및시설이름
--	region         VARCHAR2 NOT NULL, -- 지역
--	fd_name        VARCHAR2 NOT NULL, -- 대표자
--	fd_phone       VARCHAR2 NOT NULL, -- 연락처
--	fd_goal        NUMBER   NOT NULL, -- 후원모금액
--	fd_start       DATE     NOT NULL, -- 시작일
--	fd_end         DATE     NOT NULL, -- 종료일
--	fd_imgfilename VARCHAR2 NOT NULL, -- 대표이미지
--	fd_contents    CLOB     NOT NULL  -- 후원내용
--);
--
---- 유기동물후원
--ALTER TABLE funding
--	ADD
--		CONSTRAINT PK_funding -- 유기동물후원 기본키
--		PRIMARY KEY (
--			fd_id -- 후원코드
--		);
--
---- 유기동물후원이미지
--CREATE TABLE funding_img (
--	fdimg_id   NUMBER   NOT NULL, -- 후원이미지코드
--	fk_fd_id   NUMBER   NOT NULL, -- 후원코드
--	fdimg_name VARCHAR2 NOT NULL  -- 이미지파일명
--);
--
---- 유기동물후원이미지
--ALTER TABLE funding_img
--	ADD
--		CONSTRAINT PK_funding_img -- 유기동물후원이미지 기본키
--		PRIMARY KEY (
--			fdimg_id -- 후원이미지코드
--		);
--
---- 펀딩결제
--CREATE TABLE funding_payment (
--	payment_UID    NUMBER NOT NULL, -- 결제코드
--	fk_fd_id       NUMBER NOT NULL, -- 후원코드
--	payment_total  NUMBER NOT NULL, -- 결제총액
--	payment_point  NUMBER NOT NULL, -- 결제포인트
--	payment_pay    NUMBER NOT NULL, -- 실결제금액
--	payment_date   DATE   NOT NULL, -- 결제일자
--	payment_status NUMBER NOT NULL  -- 결제상태
--);
--
---- 펀딩결제
--ALTER TABLE funding_payment
--	ADD
--		CONSTRAINT PK_funding_payment -- 펀딩결제 기본키
--		PRIMARY KEY (
--			payment_UID -- 결제코드
--		);
--
---- 펀딩환불
--CREATE TABLE funding_refund (
--	refund_UID     VARCHAR2 NOT NULL, -- 환불코드
--	fk_payment_UID NUMBER   NOT NULL, -- 결제코드
--	fk_idx         NUMBER   NOT NULL, -- 환불받을회원번호
--	refund_DATE    DATE     NOT NULL, -- 환불신청일자
--	add_DATE       DATE     NOT NULL, -- 사용일자
--	refund_reason  VARCHAR2 NOT NULL, -- 환불사유
--	refund_money   NUMBER   NOT NULL, -- 환불금액
--	refund_status  NUMBER   NOT NULL  -- 승인여부
--);
--
---- 펀딩환불
--ALTER TABLE funding_refund
--	ADD
--		CONSTRAINT PK_funding_refund -- 펀딩환불 기본키
--		PRIMARY KEY (
--			refund_UID -- 환불코드
--		);
------------------------------------------------------------------------------


-- #제약조건 추가


-- 의료진
ALTER TABLE doctors
	ADD
		CONSTRAINT FK_biz_info_TO_doctors -- 기업회원상세 -> 의료진
		FOREIGN KEY (
			fk_idx_biz -- 병원/약국고유번호
		)
		REFERENCES biz_info ( -- 기업회원상세
			idx_biz -- 병원/약국고유번호
		);


-- 리뷰
ALTER TABLE review
	ADD
		CONSTRAINT FK_biz_info_TO_review -- 기업회원상세 -> 리뷰
		FOREIGN KEY (
			fk_idx_biz -- 병원/약국고유번호
		)
		REFERENCES biz_info ( -- 기업회원상세
			idx_biz -- 병원/약국고유번호
		);

-- 리뷰
ALTER TABLE review
	ADD
		CONSTRAINT FK_member_TO_review -- 회원 -> 리뷰
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 리뷰
ALTER TABLE review
	ADD
		CONSTRAINT FK_reservation_TO_review -- 예약 -> 리뷰
		FOREIGN KEY (
			fk_reservation_UID -- 예약코드
		)
		REFERENCES reservation ( -- 예약
			reservation_UID -- 예약코드
		);

-- 예약
ALTER TABLE reservation
	ADD
		CONSTRAINT FK_pet_info_TO_reservation -- 반려동물정보 -> 예약
		FOREIGN KEY (
			fk_pet_UID -- 반려동물코드
		)
		REFERENCES pet_info ( -- 반려동물정보
			pet_UID -- 반려동물코드
		);


-- 반려동물정보
ALTER TABLE pet_info
	ADD
		CONSTRAINT FK_member_TO_pet_info -- 회원 -> 반려동물정보
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 접종내용
--ALTER TABLE shots
--	ADD
--		CONSTRAINT FK_vaccine_TO_shots -- 백신 -> 접종내용
--		FOREIGN KEY (
--			fk_vaccine_UID -- 백신코드
--		)
--		REFERENCES vaccine ( -- 백신
--			vaccine_UID -- 백신코드
--		);

-- 접종내용
--ALTER TABLE shots
--	ADD
--		CONSTRAINT FK_pet_info_TO_shots -- 반려동물정보 -> 접종내용
--		FOREIGN KEY (
--			fk_pet_UID -- 반려동물코드
--		)
--		REFERENCES pet_info ( -- 반려동물정보
--			pet_UID -- 반려동물코드
--		);

-- 반려동물목록
--ALTER TABLE pet_list
--	ADD
--		CONSTRAINT FK_member_TO_pet_list -- 회원 -> 반려동물목록
--		FOREIGN KEY (
--			fk_idx -- 회원고유번호
--		)
--		REFERENCES member ( -- 회원
--			idx -- 회원고유번호
--		);

-- 반려동물목록
--ALTER TABLE pet_list
--	ADD
--		CONSTRAINT FK_pet_info_TO_pet_list -- 반려동물정보 -> 반려동물목록
--		FOREIGN KEY (
--			fk_pet_UID -- 반려동물코드
--		)
--		REFERENCES pet_info ( -- 반려동물정보
--			pet_UID -- 반려동물코드
--		);

-- 반려동물케어
ALTER TABLE petcare
	ADD
		CONSTRAINT FK_pet_info_TO_petcare -- 반려동물정보 -> 반려동물케어
		FOREIGN KEY (
			fk_pet_UID -- 반려동물코드
		)
		REFERENCES pet_info ( -- 반려동물정보
			pet_UID -- 반려동물코드
		);

-- 반려동물케어
ALTER TABLE petcare
	ADD
		CONSTRAINT FK_caretype_TO_petcare -- 케어타입 -> 반려동물케어
		FOREIGN KEY (
			fk_caretype_UID -- 케어타입코드
		)
		REFERENCES caretype ( -- 케어타입
			caretype_UID -- 케어타입코드
		);

-- 진료기록
ALTER TABLE chart
	ADD
		CONSTRAINT FK_pet_info_TO_chart -- 반려동물정보 -> 진료기록
		FOREIGN KEY (
			fk_pet_UID -- 반려동물코드
		)
		REFERENCES pet_info ( -- 반려동물정보
			pet_UID -- 반려동물코드
		);

-- 진료기록
ALTER TABLE chart
	ADD
		CONSTRAINT FK_member_TO_chart -- 회원 -> 진료기록
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 예치금결제
ALTER TABLE payment
	ADD
		CONSTRAINT FK_reservation_TO_payment -- 예약 -> 예치금결제
		FOREIGN KEY (
			fk_reservation_UID -- 예약코드
		)
		REFERENCES reservation ( -- 예약
			reservation_UID -- 예약코드
		);

-- 예치금
ALTER TABLE deposit
	ADD
		CONSTRAINT FK_member_TO_deposit -- 회원 -> 예치금
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 환불
--ALTER TABLE refund
--	ADD
--		CONSTRAINT FK_payment_TO_refund -- 예치금결제 -> 환불
--		FOREIGN KEY (
--			fk_payment_UID -- 결제코드
--		)
--		REFERENCES payment ( -- 예치금결제
--			payment_UID -- 결제코드
--		);


-- 1:1상담
ALTER TABLE consult
	ADD
		CONSTRAINT FK_member_TO_consult -- 회원 -> 1:1상담
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 알림
ALTER TABLE notification
	ADD
		CONSTRAINT FK_member_TO_notification -- 회원 -> 알림
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 예치금출금
--ALTER TABLE withdraw
--	ADD
--		CONSTRAINT FK_deposit_TO_withdraw -- 예치금 -> 예치금출금
--		FOREIGN KEY (
--			fk_deposit_UID -- 예치금코드
--		)
--		REFERENCES deposit ( -- 예치금
--			deposit_UID -- 예치금코드
--		);

-- 예치금 사용내역
--ALTER TABLE dep_use
--	ADD
--		CONSTRAINT FK_deposit_TO_dep_use -- 예치금 -> 예치금 사용내역
--		FOREIGN KEY (
--			fk_deposit_UID -- 예치금코드
--		)
--		REFERENCES deposit ( -- 예치금
--			deposit_UID -- 예치금코드
--		);

-- 예치금 사용내역
--ALTER TABLE dep_use
--	ADD
--		CONSTRAINT FK_payment_TO_dep_use -- 예치금결제 -> 예치금 사용내역
--		FOREIGN KEY (
--			fk_payment_UID -- 결제코드
--		)
--		REFERENCES payment ( -- 예치금결제
--			payment_UID -- 결제코드
--		);

-- 예치금 사용내역
--ALTER TABLE dep_use
--	ADD
--		CONSTRAINT FK_reservation_TO_dep_use -- 예약 -> 예치금 사용내역
--		FOREIGN KEY (
--			fk_reservation_UID -- 예약코드
--		)
--		REFERENCES reservation ( -- 예약
--			reservation_UID -- 예약코드
--		);

-- 처방전
ALTER TABLE prescription
	ADD
		CONSTRAINT FK_chart_TO_prescription -- 진료기록 -> 처방전
		FOREIGN KEY (
			chart_UID -- 차트코드
		)
		REFERENCES chart ( -- 진료기록
			chart_UID -- 차트코드
		);

-- 화상 상담(video advice)
ALTER TABLE video_advice
	ADD
		CONSTRAINT FK_member_TO_video_advice -- 회원 -> 화상 상담(video advice)
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 화상 상담(video advice)
ALTER TABLE video_advice
	ADD
		CONSTRAINT FK_biz_info_TO_video_advice -- 기업회원상세 -> 화상 상담(video advice)
		FOREIGN KEY (
			fk_idx_biz -- 병원/약국고유번호
		)
		REFERENCES biz_info ( -- 기업회원상세
			idx_biz -- 병원/약국고유번호
		);


-- 리뷰댓글(reviewComment)
ALTER TABLE review_comment
	ADD
		CONSTRAINT FK_review_TO_review_comment -- 리뷰 -> 리뷰댓글(reviewComment)
		FOREIGN KEY (
			fk_review_UID -- 리뷰코드
		)
		REFERENCES review ( -- 리뷰
			review_UID -- 리뷰코드
		);

-- 리뷰댓글(reviewComment)
ALTER TABLE review_comment
	ADD
		CONSTRAINT FK_member_TO_review_comment -- 회원 -> 리뷰댓글(reviewComment)
		FOREIGN KEY (
			fk_idx -- 회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 1:1상담 댓글
ALTER TABLE consult_comment
	ADD
		CONSTRAINT FK_consult_TO_consult_comment -- 1:1상담 -> 1:1상담 댓글
		FOREIGN KEY (
			fk_consult_UID -- 상담코드
		)
		REFERENCES consult ( -- 1:1상담
			consult_UID -- 상담코드
		);

-- 1:1상담 댓글
ALTER TABLE consult_comment
	ADD
		CONSTRAINT FK_member_TO_consult_comment -- 회원 -> 1:1상담 댓글
		FOREIGN KEY (
			fk_idx -- 댓글회원고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 펫케어 이미지
ALTER TABLE petcare_img
	ADD
		CONSTRAINT FK_petcare_TO_petcare_img -- 반려동물케어 -> 펫케어 이미지
		FOREIGN KEY (
			fk_care_UID -- 케어코드
		)
		REFERENCES petcare ( -- 반려동물케어
			care_UID -- 케어코드
		);
        
        
-- #보조기능 관련 제약조건 추가
-- 게시글
ALTER TABLE board_post
	ADD
		CONSTRAINT FK_board_group_TO_board_post -- 게시판그룹 -> 게시글
		FOREIGN KEY (
			fk_brd_id -- 게시판그룹코드
		)
		REFERENCES board_group ( -- 게시판그룹
			brd_id -- 게시판그룹코드
		)
		
		;

-- 게시글
ALTER TABLE board_post
	ADD
		CONSTRAINT FK_member_TO_board_post -- 회원 -> 게시글
		FOREIGN KEY (
			fk_idx -- 작성자고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		)
		
		;

-- 댓글
ALTER TABLE board_comment
	ADD
		CONSTRAINT FK_board_group_TO_comment -- 게시판그룹 -> 댓글
		FOREIGN KEY (
			fk_brd_id -- 게시판그룹코드
		)
		REFERENCES board_group ( -- 게시판그룹
			brd_id -- 게시판그룹코드
		);

-- 댓글
ALTER TABLE board_comment
	ADD
		CONSTRAINT FK_board_post_TO_comment -- 게시글 -> 댓글
		FOREIGN KEY (
			fk_post_id -- 게시글고유번호
		)
		REFERENCES board_post ( -- 게시글
			post_id -- 게시글고유번호
		)
		
		;

-- 댓글
ALTER TABLE board_comment
	ADD
		CONSTRAINT FK_member_TO_comment -- 회원 -> 댓글
		FOREIGN KEY (
			fk_idx -- 댓글작성자고유번호
		)
		REFERENCES member ( -- 회원
			idx -- 회원고유번호
		);

-- 유기동물후원이미지
--ALTER TABLE funding_img
--	ADD
--		CONSTRAINT FK_funding_TO_funding_img -- 유기동물후원 -> 유기동물후원이미지
--		FOREIGN KEY (
--			fk_fd_id -- 후원코드
--		)
--		REFERENCES funding ( -- 유기동물후원
--			fd_id -- 후원코드
--		);

-- 펀딩결제
--ALTER TABLE funding_payment
--	ADD
--		CONSTRAINT FK_funding_TO_funding_payment -- 유기동물후원 -> 펀딩결제
--		FOREIGN KEY (
--			fk_fd_id -- 후원코드
--		)
--		REFERENCES funding ( -- 유기동물후원
--			fd_id -- 후원코드
--		);

-- 펀딩환불
--ALTER TABLE funding_refund
--	ADD
--		CONSTRAINT FK_funding_payment_TO_funding_refund -- 펀딩결제 -> 펀딩환불
--		FOREIGN KEY (
--			fk_payment_UID -- 결제코드
--		)
--		REFERENCES funding_payment ( -- 펀딩결제
--			payment_UID -- 결제코드
--		);
        

-- 관리자 회원 리스트 프로시저(검색X 정렬X) ++ [190125] 프로시저 where절 추가
create or replace procedure pcd_selectMemberList
(   p_startno       IN      member.idx%TYPE
  , p_endno         IN      member.idx%TYPE
  , cur_member_list OUT     SYS_REFCURSOR
)
is
begin
    OPEN cur_member_list FOR
    select rno, idx, userid, name, nickname, phone, noshow, member_status, lastlogindategap
    from
    (
        select rownum as rno, idx, userid, name, nickname, phone, noshow, member_status, lastlogindategap
        from 
        (
            select a.idx, userid, name, nickname, phone, noshow, member_status
                , trunc(months_between(sysdate, lastlogindate)) AS lastlogindategap
            from member a JOIN login_log b
            ON a.idx = b.idx
            where a.membertype = 1
            order by idx asc
        ) V
    ) T
    where rno between p_startno and p_endno;
end pcd_selectMemberList;

-- [190126] 병원회원의 최초 예약스케줄 생성 프로시저 (학원PC에는 생성되어있음)
create or replace procedure pcd_firstAddSchedule(p_idx_biz IN number)
is
    v_weekday varchar2(1); 
begin
        select substr(weekday, -2, 1) as weekday into v_weekday from biz_info where idx_biz = p_idx_biz;
        
        if(v_weekday='5')
        then
            insert into schedule(schedule_UID, fk_idx_biz, schedule_DATE)
            select seq_schedule_UID.nextval, idx_biz, scheduledate
            from
            (
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select wdstart s,
                           lunchstart e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '7') 
            ) V
            on 1=1
            UNION
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select lunchend s,
                           wdend e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '7') 
            ) V
            on 1=1
            order by 1);
            
        elsif(v_weekday=4)
        then
            insert into schedule(schedule_UID, fk_idx_biz, schedule_DATE)
            select seq_schedule_UID.nextval, idx_biz, scheduledate
            from
            (
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select wdstart s,
                           lunchstart e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '2', '7') 
            ) V
            on 1=1
            UNION
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select lunchend s,
                           wdend e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '2', '7') 
            ) V
            on 1=1
            order by 1);
        elsif(v_weekday='3')
        then
            insert into schedule(schedule_UID, fk_idx_biz, schedule_DATE)
            select seq_schedule_UID.nextval, idx_biz, scheduledate
            from
            (
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select wdstart s,
                           lunchstart e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '3', '5', '7') 
            ) V
            on 1=1
            UNION
            select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
            from
            (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
             from   (select lunchend s,
                           wdend e,
                           idx_biz
                    from   biz_info
                    where idx_biz = p_idx_biz)
            connect by s + (((level*0.5)-0.5)/24) < e) T
            left join 
            (
            SELECT A.DT
              FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                               TO_CHAR (SDT + LEVEL - 1, 'D') D
                          FROM (SELECT sysdate SDT,
                                       sysdate+14  EDT
                                  FROM dual)
                    CONNECT BY LEVEL <= EDT - SDT + 1) A
            WHERE A.D NOT IN ('1', '3', '5', '7') 
            ) V
            on 1=1
            order by 1);
        end if;
        insert into schedule(schedule_UID, fk_idx_biz, schedule_DATE)
        select seq_schedule_UID.nextval, idx_biz, scheduledate
        from
        (
        select idx_biz, to_date(V.DT || ''|| T.time_str, 'yyyy-mm-dd hh24:mi') as scheduledate
        from
        (select to_char(s + (((level*0.5)-0.5)/24), 'hh24:mi') as time_str, idx_biz
         from   (select satstart s,
                       satend e,
                       idx_biz
                from   biz_info
                where idx_biz = p_idx_biz)
        connect by s + (((level*0.5)-0.5)/24) < e) T
        left join 
        (
        SELECT A.DT, A.D
          FROM (    SELECT TO_CHAR (SDT + LEVEL - 1, 'YYYYMMDD') DT,
                           TO_CHAR (SDT + LEVEL - 1, 'D') D
                      FROM (SELECT sysdate SDT,
                                   sysdate+14  EDT
                              FROM dual)
                CONNECT BY LEVEL <= EDT - SDT + 1) A
        WHERE A.D = '7'
        ) V
        on 1=1
        order by 1
        );
end;

--insert into caretype(caretype_UID, caretype_name, caretype_info)
--values(seq_caretype_UID.nextval, '식사', '<p>각 항목 작성 안내사항<br/>[식사의 경우]</p>');

commit;

-- [190129] 예약 리스트에 필요한 view
create or replace view view_biz_memberinfo as 
select idx_biz, name as biz_name, phone, postcode, addr1, addr2
from member join biz_info
on idx = idx_biz;

-- [190207] 맞춤추천에 필요한 function
create or replace function func_BestHospital
(p_idx IN member.idx%TYPE)
return member.idx%TYPE
is
    v_result    varchar2(4);
begin                    
    select fk_idx_biz INTO v_result
    from
    (
        select rownum as rno, fk_idx_biz, cnt
        from 
        (
            select fk_idx_biz, count(*) as cnt
            from reservation
            where fk_idx = p_idx and reservation_status = 3
            group by fk_idx_biz
            order by cnt desc
        )
    )
    where rno = 1;
    
    return v_result;
end;


-- [190211] petcare 테이블에서 notification 테이블로 insert하는 프로시저 
--create or replace procedure pcd_petcare_insert_not
--is
--begin
--    insert into notification(not_UID, fk_idx, not_type, not_message, not_date, not_readcheck, not_remindstatus, not_time, not_url)
--    select seq_notification_UID.nextval,(select distinct i.fk_idx from pet_info I join petcare C on i.pet_uid = c.fk_pet_uid where c.care_date = to_char(sysdate, 'yyyy-mm-dd hh24:mi')) as fk_idx, 1
--         , care_contents, to_date(care_date, 'yyyy-mm-dd hh24:mi'), 0, 0, sysdate, 'http://localhost:9090/petopia/notificationList.pet'
--    from petcare
--    where care_date = to_char(sysdate, 'yyyy-mm-dd hh24:mi');
--     
--    commit;
--end pcd_petcare_insert_not;

-- [190211] 프로시저 수정
create or replace procedure pcd_petcare_insert_not
is

begin
    for rcd in (
    select i.fk_idx, care_contents, to_date(care_date, 'yyyy-mm-dd hh24:mi') as care_date 
    from pet_info I join petcare C
    on i.pet_uid = c.fk_pet_uid
    where c.care_date = to_char(sysdate, 'yyyy-mm-dd hh24:mi')
    )
    
    loop
         insert into notification(not_UID, fk_idx, not_type, not_message, not_date, not_readcheck, not_remindstatus, not_time, not_url)
         values(seq_notification_UID.nextval, rcd.fk_idx, 1, rcd.care_contents,  rcd.care_date, 0, 0, sysdate, 'http://localhost:9090/petopia/notificationList.pet');
    end loop;
    commit;
    
end pcd_petcare_insert_not;

-- [190211] petcare 테이블에서 notification 테이블로 insert하는 프로시저 job 등록
declare 
    jobno number;
begin
    SYS.DBMS_JOB.SUBMIT(
        job   => jobno 
        ,what => 'FINAL2.PCD_PETCARE_INSERT_NOT;' 
        ,next_date => SYSDATE
        ,interval => 'SYSDATE + 1/60/24'
        ,no_parse => TRUE
    );
end;
commit;

SELECT * FROM USER_JOBS;

-- [190213] petweight 테이블 insert 프로시저 생성
create or replace procedure pcd_petweight_insert
(p_fk_pet_UID           IN  petweight.fk_pet_UID%type
,p_petweight_past       IN  petweight.petweight_past%type
,p_petweight_targeted   IN  petweight.petweight_targeted%type
,p_petweight_date       IN  petweight.petweight_date%type
)
is
begin
      insert into petweight(petweight_UID, fk_pet_UID, petweight_past, petweight_targeted, petweight_date) 
      values(seq_petweight_UID.nextval, p_fk_pet_UID, p_petweight_past, p_petweight_targeted, p_petweight_date);
end pcd_petweight_insert;