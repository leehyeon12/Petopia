/*
	 ※ 관련용어 ※
	 - 암호(Cryptography) : 해독 불가능한 형태로 변환하거나 또는 암호화된 메시지를 해독 가능한 형태로 변환하는 기술
	 - 평문(Plaintext)    : 해독 가능한 형태의 메시지
	 - 암호문(Ciphertext) : 해독 불가능한 형태의 메시지
	 - 암호화(Encryption) : 평문을 암호문으로 변환하는 과정
	 - 복호화(Decryption) : 암호문을 평문으로 변환하는 과정
	 - 대칭키 암호(또는 비밀키 암호) : 암호화키와 복호화키가 같은 암호
	 - 비대칭키 암호(또는 공개키 암호) : 암호화키와 복호화키가 다른 암호
	
	
	※ 양방향 암호화 알고리즘(AES-256 Advanced Encryption Standard) ※
	
	  양방향 암호화 알고리즘은 평문에서 암호문으로, 암호문에서 평문으로 변환하는 암호화 및 복호화가 이루어지는 알고리즘 이다. 
	  많이 사용하는 알고리즘은 AES-256 입니다. 
	  주로 이름, 주소, 연락처 등 복호화 하는데 필요한 정보를 이 알고리즘을 이용해서 암호문으로 관리한다.
	 
	 ※※※  Java 를 이용한 구현  ※※※
	 == 개발전 준비단계 ==
	  기본으로 제공하는 JDK를 설치하면 암호 알고리즘을 만들 수 있는 API가 제공되지만, 
	 AES-128 보다 한단계 더 높은 단계인 AES-256을 구현하기 위해서는 별도의 라이브러리 확장 파일이 필요하다.
	 오라클사 홈페이지의 JDK 다운로드 페이지에 가면 아래처럼 JCE 를 다운받는다.
	  자신의 JRE 버전에 맞는 해당 파일을 다운로드 받아서 압축을 푼 후 local_policy.jar 파일과 US_export_policy.jar 파일을
	 JDK설치경로\jre\lib\security 와  JRE설치경로\lib\security 에 
	 local_policy.jar 파일과 US_export_policy.jar 두개 파일을 모두 붙여넣기를 하여 덮어쓴다.
	 (Linux 계열에는 JDK설치경로에만 넣어주면 해결됨)
	 (JDK 설치 경로를 모르면 내컴퓨터 우클릭 > 속성 > 고급 시스템 설정 > 환경변수 > JAVA_HOME을 찾는다)
	  그런 다음에 WAS(톰캣)를 재구동한다. 
	  
	 https://mvnrepository.com/artifact/commons-codec/commons-codec 에 가서
	 여러가지 버전이 있는데 1.11 에 들어가서 jar(327 KB)를 클릭하여 다운을 받는다. 
	 다운받은 파일명은 commons-codec-1.11.jar 인데 이 파일을 C:\Program Files\Java\jdk1.8.0_112\jre\lib\ext 경로에 붙여둔다.
	 해당 프로젝트의 Build Path 에 가서 Libraies 탭에서 Add External JARs.. 를 클릭하여 commons-codec-1.11.jar 파일을 직접 올려둔다. 
	   
	
	 >>> JDK 버전별 Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 다운로드 경로 <<<
	 jdk8 (Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 8)
	 https://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
	
	 jdk7 (Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 7)
	 http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html
	 
	
	 jdk6 (Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 6)
	 http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html  
*/

package com.final2.petopia.common;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

//===== #43. 양방향 암호화 알고리즘인 AES256 암호화를 지원하는 클래스 생성하기
//(기본생성자가 없으므로 @Component 를 쓰면 오류가 발생한다. 
//그래서 servlet-context.xml 파일에 직접 파라미터가 있는 생성자로 bean 등록을 해주었다.) =====

/**
 * 양방향 암호화 알고리즘인 AES256 암호화를 지원하는 클래스
 */
public class AES256 {
    private String iv;
    private Key keySpec;

    /** 
     * 생성자
     * 16자리의 키값을 입력하여 객체를 생성한다.
     * @param key 암호화/복호화를 위한 키값
     * @throws UnsupportedEncodingException 키값의 길이가 16이하일 경우 발생
     */
    public AES256(String key) throws UnsupportedEncodingException {
        this.iv = key.substring(0, 16);
        byte[] keyBytes = new byte[16];
        byte[] b = key.getBytes("UTF-8");
        int len = b.length;
        if(len > keyBytes.length){
            len = keyBytes.length;
        }
        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

        this.keySpec = keySpec;
    }

    /**
     * AES256 으로 암호화 한다.
     * @param str 암호화할 문자열
     * @return String
     * @throws NoSuchAlgorithmException
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    public String encrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException{
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
        byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
        String enStr = new String(Base64.encodeBase64(encrypted));
        return enStr;
    }

    /**
     * AES256으로 암호화된 txt 를 복호화한다.
     * @param str 복호화할 문자열
     * @return
     * @throws NoSuchAlgorithmException
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    public String decrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
        byte[] byteStr = Base64.decodeBase64(str.getBytes());
        return new String(c.doFinal(byteStr), "UTF-8");
    }

}// end of class AES256///////////////////////////////////////
