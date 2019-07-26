using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Security.Cryptography;
using System.Text;

public partial class payReqSmart : System.Web.UI.Page{
    protected String buyerName;
    protected String buyerTel;
    protected String buyerEmail;
    protected String charSet;   
    protected String ediDate;
    protected String editDate;
    protected String goodsCl;
    protected String goodsName;
    protected String goodsCnt;
    protected String hash_String;
    protected String moid;
    protected String merchantKey;
    protected String merchantID;
    protected String price;
    protected String returnURL;
    
    protected void Page_Load(object sender, EventArgs e){
         requestPay();
         stringToSHA256();   
    }

    /********************************************************** 
    * <결제요청 파라미터>
    * 결제시 Form 에 보내는 결제요청 파라미터입니다.
    * 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
    * 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
    **********************************************************/
    public void requestPay(){
        merchantKey = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg=="; // 상점키
        merchantID  = "nicepay00m";                                         // 상점아이디
        buyerEmail  = "happy@day.co.kr";                                    // 구매자메일주소
        buyerName   = "나이스";                                             // 구매자명
        buyerTel    = "01000000000";                                        // 구매자연락처
        charSet     = "utf-8";                                              // 인코딩
        ediDate     = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    // 해쉬암호화
        goodsName   = "나이스페이";                                         // 결제상품명
        goodsCnt    = "1";                                                  // 결제상품개수
        goodsCl     = "1";                                                  // 상품구분 실물(1), 컨텐츠(0)
        price       = "1004";                                               // 결제상품금액
        moid        = "nicepay0001";                                        // 상품주문번호
        returnURL   = "http://localhost:51212/payResult.aspx";              // 결과페이지     
    }

    public String TomorrowDateString(){
        DateTime dt = DateTime.Now;
        DateTime tomorrow = dt.AddDays(1);
        String tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);
        return tomorrowString;
    }

    public void stringToSHA256(){
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(ediDate + merchantID + price + merchantKey))).ToLower();
        hash_String = getHashString.Replace("-", "");
    }
}
