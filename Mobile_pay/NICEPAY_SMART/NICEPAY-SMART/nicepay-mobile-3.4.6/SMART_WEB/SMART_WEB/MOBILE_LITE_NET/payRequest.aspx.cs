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
    * <������û �Ķ����>
    * ������ Form �� ������ ������û �Ķ�����Դϴ�.
    * ���������������� �⺻(�ʼ�) �Ķ���͸� ���õǾ� ������, 
    * �߰� ������ �ɼ� �Ķ���ʹ� �����޴����� �����ϼ���.
    **********************************************************/
    public void requestPay(){
        merchantKey = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg=="; // ����Ű
        merchantID  = "nicepay00m";                                         // �������̵�
        buyerEmail  = "happy@day.co.kr";                                    // �����ڸ����ּ�
        buyerName   = "���̽�";                                             // �����ڸ�
        buyerTel    = "01000000000";                                        // �����ڿ���ó
        charSet     = "utf-8";                                              // ���ڵ�
        ediDate     = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    // �ؽ���ȣȭ
        goodsName   = "���̽�����";                                         // ������ǰ��
        goodsCnt    = "1";                                                  // ������ǰ����
        goodsCl     = "1";                                                  // ��ǰ���� �ǹ�(1), ������(0)
        price       = "1004";                                               // ������ǰ�ݾ�
        moid        = "nicepay0001";                                        // ��ǰ�ֹ���ȣ
        returnURL   = "http://localhost:51212/payResult.aspx";              // ���������     
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
