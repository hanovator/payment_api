<!--#include file="NICELog.asp"-->
<%

Class clssNICEpay

	'결제 요청 data

	private m_type
	private m_mid
	private m_paymethod
	private m_goodname
	private m_currency
	private m_price
	private m_amt
	private m_buyername
	private m_buyertel
	private m_buyeremail
	private m_parentemail
	private m_buyeraddr

	'KEY-IN
	Private m_cardexpire
	Private m_cardno
	Private m_auth_flg
	Private m_cardinterest
	Private m_cardquota
	Private m_buyerauthnum
	Private m_cardpwd

	private m_recvname
	private m_recvtel
	private m_recvaddr
	private m_recvpostnum
	private m_recvmsg
	private m_sessionkey
	private m_encrypted
	private m_merchantres1
	private m_merchantres2
	private m_merchantres3
	private m_oid
	private m_url
	private m_merchantkey
	private m_proid
	private m_posted
	private m_msg

	public  m_log
	private m_tid
	private m_send_data
	private m_recv_data
	private m_netcancel_recv_data
	private m_status
	private m_debug

	private m_returnurl
	private m_retryurl

	private m_goodscl
	private m_trkey

	private m_edidate
	private m_mallreserved

	private m_mallip
	private m_encodeparameters
	private m_userip

	' 에스크로 배송등록 요청 정보
	Private m_reqtype
	Private m_delivery_co_nm
	Private m_invoice_num
	Private m_register_name

	Private m_confirm_mail

	Private m_reject_reason
	Private m_refund_account
	Private m_refund_bank_code
	Private m_refund_name

	' 현금영수증 발급요청 정보
	private m_reg_num
	private m_useopt
	private m_sup_price
	private m_tax
	private m_srvc_price

	private m_netcancelpwd  '망 취소 패스워드
	private m_netcancelamt  '망 취소 금액
	private m_encodekey     '상점키

	private m_start_time
	private m_logdir
	private m_cancelpwd
	private m_cancelamt
	Private m_cancelmsg
	Private m_partialcancelcode

	Private m_charset		'charset
	
	' 20180410 가맹점 모듈 버전 정보 
	Private m_version_info
	Private m_module_info
	' 20180411 작성 언어 구분
	Private m_litetype

	Private r_ResultCode
	Private r_ResultMsg
	Private r_ErrorMsg
	Private r_ErrorCD
	Private r_AuthDate
	Private r_AuthCode
	Private r_BuyerName
	Private r_MallUserID
	Private r_GoodsName
	Private r_PayMethod
	Private r_Moid
	Private r_TID
	Private r_Amt
	Private r_CardCode
	Private r_CardName
	Private r_CardNo
	Private r_CardQuota
	Private r_CardInterest
	Private r_BankCode
	Private r_BankName
	Private r_RcptType
	Private r_RcptTID
	Private r_RcptAuthCode
	Private r_Carrier
	Private r_DstAddr
	Private r_VbankBankCode
	Private r_VbankBankName
	Private r_VbankNum
	Private r_VbankExpDate
	Private r_VbankAccountName

	Private r_CancelAmt
	Private r_CancelTime
	Private r_CancelDate

	Private r_processDate
	Private r_processTime

	private sub Class_Initialize()

		m_start_time = Timer()

		' 20180410 버전정보 추가
		m_version_info = "Ver.1.4"

		' 20180410 가맹점 모듈 버전 정보 추가
		m_module_info = "LITE^ASP_LITE_" & m_version_info

	End Sub

	private sub Class_Terminate()
		'클래스 종료 처리
		f_logString = "END " & UCase(m_type)& " : " & r_resultmsg & " [lap time : " & FormatNumber(Timer() - m_start_time, 2) & " s]" & vbCrLf
		m_log.write_log f_logString '종료 로그

		Set m_log = Nothing
		'response.write "결제 종료 : "& Timer & "[" &Timer-m_start_time& "]"& "<br>"
	End Sub

	Public Function startAction()

		m_status = 0 		'처리 상태 : 1=> 정상 처리 , 0 => 비정상처리

		'로그 클래서 생성
		Set m_log = new clssNICELog

		'로그 초기화 작업
		m_log.LoggingInitialize(m_logdir)
		f_ramdum = right("0000" & make_RN(),4)	  '랜덤숫자 4자리 생성
		f_time =   right(Timer*100,2)
		m_proid = f_time & f_ramdum
		m_log.m_pgid = m_proid
		'--------------------------------------------

		m_log.m_type = m_type
		m_log.m_mid = m_mid
		m_log.m_debug = m_debug

		'결제 시작 로그
		m_log.write_log "START " & UCase(m_type) & " D20180410 NICEPAY Lite ASP " & m_version_info

		'필드 체크
		'check_field()
		'response.write "필드  체크 : "& Timer & "[" &Timer-m_start_time& "]"& "<br>"
		m_status = 1

		'결제 시에 TID 생성
		IF(m_status) AND (m_type = "securepay" OR m_type = "receipt" OR m_type = "repay") THEN
			'TID 생성 생성
			make_tid()
			'response.write "TID 생성 : "& Timer & "[" &Timer-m_start_time& "]"& "<br>"
		END IF

		IF(m_status) THEN
			make_msg()
		END IF

		'전문 통신 함수
		IF(m_status) THEN
			IF m_type = "PYO" THEN
				Field_Value = LiteRequest("payProcess.jsp", m_send_data)
			END IF

			IF m_type = "CLO" THEN
				Field_Value = LiteRequest("cancelProcess.jsp", m_send_data)
			END IF

			IF m_type = "RECEIPT" THEN
				Field_Value = LiteRequest("cashReceiptProcess.jsp", m_send_data)
			END IF

			IF m_type = "BILL" THEN
				Field_Value = LiteRequest("billingProcess.jsp", m_send_data)
			END If

			IF m_type = "ESCROW" THEN
				Field_Value = LiteRequest("escrowProcess.jsp", m_send_data)
			END IF

			IF m_type = "BILLKEY" THEN
				Field_Value = LiteRequest("billkeyProcess.jsp", m_send_data)
			END If

		END IF

	End Function

	Public sub check_field()

		IF m_type = "PYO" THEN

			m_status = 1
			IF m_mid = "" OR 10 > len(m_mid) then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "상점ID(mid) 항목 누락"			'결과내용
				m_status = 0
			END IF

			IF m_price = "" then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "금액(price) 항목 누락"			'결과내용
				m_status = 0
			END IF

			IF EncodeKey = "" then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "상점Key 항목 누락"				'결과내용
				m_status = 0
			END IF

		END IF

		IF m_type = "CLO" THEN

			m_status = 1
			IF m_mid = "" OR 10 <> len(m_mid) then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "상점ID(mid) 항목 누락"			'결과내용
				m_status = 0
			END IF

			IF m_tid = "" OR 30 <> len(m_tid) then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "TID 항목 누락"					'결과내용
				m_status = 0
			END IF

			IF m_cancelpwd = ""  then
				r_ResultCode = "9999"							'결과코드
				r_ResultMsg = "취소 패스워드 항목 누락"			'결과내용
				m_status = 0
			END IF
		END IF

		IF m_status then
			m_log.write_log "Field Check OK "
		ELSE
			m_log.write_log "Field Check FAIL  "& r_resultmsg
		END IF

	End sub

	Public sub setfield( name, value )

		Select Case name
			Case "type"
				m_type = value
			Case "mid"
				m_mid =  value
			Case "tid"
				m_tid =  value
			Case "logdir"
				m_logdir = value
			Case "NICEPAY_LOG_HOME"
				m_logdir = value
			Case "EncodeKey"
				m_encodekey = value
			Case "NetCancelAmt"
				m_netcancelamt = value
			Case "NetCancelPwd"
				m_netcancelpwd = value
			Case "CharSet"
				m_charset = value
			Case "debug"
				m_debug = value
			Case "LiteType"
				m_litetype = value
		End Select

		IF m_type = "CLO" THEN
			Select Case name
				Case "TID"
					m_tid =  value
				Case "MID"
					m_mid =  value
				Case "CancelPwd"
					m_cancelpwd =	value
				Case "CancelAmt"
					m_cancelamt =	value
				Case "CancelMsg"
					m_cancelmsg = value
				Case "PartialCancelCode"
					m_partialcancelcode = value
			End Select
		END IF

	End sub


	Public Function make_RN ()

		dim Ranval
		dim iniLite_RN_default

		iniLite_RN_default	=	9999
		randomize
		Ranval = Int((iniLite_RN_default * Rnd) + 1)
		make_RN = Ranval

	End Function


	Public Function getResult(name)

		getResult =  eval("r_"&name)
		'Response.Write "name :" & name & "   " &  getResult

	End Function


	Public sub make_tid

		f_yy = year(now)
		f_mm = right("0" & month(now),2)
		f_dd = right("0" & day(now),2)
		f_hh = right("0" & hour(now),2)
		f_mi = right("0" & minute(now),2)
		f_ss = right("0" & second(now),2)

		f_DateStr	=	f_yy & f_mm & f_dd & f_hh & f_mi & f_ss

		m_tid		=	m_pgid & m_mid & f_DateStr & m_proid		'TID 생성.

		if 40 = Len(m_tid) then
			m_status = 1
			f_logString	=	"MAKE TID OK : " & m_tid
			m_log.write_log  f_logString
		else
			m_status = 0
			r_ResultCode = "01"
			r_ResultMsg = "TID 생성 오류"
			r_resulterr = "9014"
			f_logString = "MAKE TID FAIL : " & r_resultmsg & vbCrLf & m_tid
			m_log.write_log  f_logString
		end if

	End sub


	Public Function make_msg ()

		IF m_type = "PYO" THEN

			m_returnurl = Request.Form("ReturnURL")
			m_retryurl = Request.Form("RetryURL")
			m_amt = Request.Form("Amt")
			m_subid = Request.Form("SUB_ID")
			m_parentemail  = Request.Form("ParentEmail")
			m_buyeremail = Request.Form("BuyerEmail")
			m_goodscnt = Request.Form("GoodsCnt")
			m_malluserid= Request.Form("MallUserID")
			m_mid = Request.Form("MID")
			m_buyertel = Request.Form("BuyerTel")
			m_goodscl = Request.Form("GoodsCl")
			m_mallip = Request.Form("MallIP")
			m_vbankexpdate = Request.Form("VbankExpDate")
			m_oid = Request.Form("Moid")
			m_transtype = Request.Form("TransType")
			m_encodeparameters = Request.Form("EncodeParameters")
			m_paymethod = Request.Form("PayMethod")
			m_userip = Request.Form("UserIP")

			If UCase(m_charset) = "UTF-8" Then
				m_buyername = server.URLEncode(escape(Request.Form("BuyerName")))
				m_goodname = server.URLEncode(escape(Request.Form("GoodsName")))
				m_buyeraddr =  server.URLEncode(escape(Request.Form("BuyerAddr")))
			Else
				m_buyername = server.URLEncode(Request.Form("BuyerName"))
				m_goodname = server.URLEncode(Request.Form("GoodsName"))
				m_buyeraddr = server.URLEncode(Request.Form("BuyerAddr"))
			END If

			m_tid = Request.Form("TID")
			m_mallreserved = Request.Form("MallReserved")
			m_trkey = Request.Form("TrKey")
			m_edidate = Request.Form("EdiDate")
			m_encrypted = Request.Form("EncryptData")

			m_cardexpire = Request.Form("CardExpire")
			m_cardno = Request.Form("CardNo")
			m_cardinterest = Request.Form("CardInterest")
			m_auth_flg = Request.Form("AuthFlg")
			m_cardquota = Request.Form("CardQuota")
			m_buyerauthnum = Request.Form("BuyerAuthNum")
			m_cardpwd = Request.Form("CardPwd")

			' 20180410 가맹점 모듈 정보 추가 (신규 필드 추가 없이 전문공통헤더의 ErrorMsg 필드를 이용하기로 함)

			m_send_data = "TransType="&m_transtype&"&GoodsName="&m_goodname&"&Amt="&m_amt&"&Moid="&m_oid& _
							"&BuyerName="&m_buyername&"&BuyerEmail="&server.URLEncode(m_buyeremail)&"&BuyerTel="&m_buyertel& _
							"&MID="&m_mid&"&GoodsCl="&m_goodscl&"&PayMethod="&m_paymethod&"&GoodsCnt="&m_goodscnt&"&BuyerAddr="&m_buyeraddr& _
							"&UserIP="&m_userip&"&MallIP="&m_mallip&"&VbankExpDate="&m_vbankexpdate&"&MallUserID="&m_malluserid& _
							"&EncodeParameters="&server.URLEncode(m_encodeparameters)&"&EdiDate="&m_edidate&"&EncryptData="&m_encrypted& _
							"&EncodeKey="&server.URLEncode(m_encodekey)&"&CardExpire="&m_cardexpire&"&CardNo="&m_cardno& _
							"&CardInterest="&m_cardinterest&"&AuthFlg="&m_auth_flg&"&CardQuota="&m_cardquota&"&BuyerAuthNum="&m_buyerauthnum&"&CardPwd="&m_cardpwd& _
							"&TrKey="&m_trkey&"&TID="&m_tid&"&CharSet="&m_charset&"&ErrorMsg="&m_module_info

			m_log.write_log "TID : " & m_tid

		END IF

		IF m_type = "CLO" Then

			If UCase(m_charset) = "UTF-8" Then
				m_cancelmsg = server.URLEncode(escape(m_cancelmsg))
			Else
				m_cancelmsg = server.URLEncode(m_cancelmsg)
			END If

			' 20180410 가맹점 모듈 정보 추가 (신규 필드 추가 없이 전문공통헤더의 ErrorMsg 필드를 이용하기로 함)

			m_send_data = "MID="&m_mid&"&CancelMsg="&m_cancelmsg&"&TID="&m_tid&"&CancelAmt="&m_cancelamt& _
							"&CancelPwd="&m_cancelpwd&"&PartialCancelCode="&m_partialcancelcode&"&ErrorMsg="&m_module_info

		END IF


		IF m_type = "ESCROW" THEN

			m_reqtype = Request.Form("ReqType")
			m_buyerauthnum = Request.Form("BuyerAuthNum")
			m_buyeremail = Request.Form("BuyerEmail")
			m_mid = Request.Form("MID")
			m_mallip = Request.Form("MallIP")
			m_paymethod = Request.Form("PayMethod")
			m_userip = Request.Form("UserIP")
			m_tid = Request.Form("TID")
			m_mallreserved = Request.Form("MallReserved")
			m_invoice_num = Request.Form("InvoiceNum")

			If UCase(m_charset) = "UTF-8" Then
				m_delivery_co_nm = server.URLEncode(escape(Request.Form("DeliveryCoNm")))	' 배송업체명
				m_register_name = server.URLEncode(escape(Request.Form("RegisterName")))	' 등록자 이름
				m_buyeraddr = server.URLEncode(escape(Request.Form("BuyerAddr")))			' 배송지 주소
				m_reject_reason = server.URLEncode(escape(Request.Form("RejectReason")))	' 구매거절 사유
				m_refund_name = server.URLEncode(escape(Request.Form("RefundName")))		' 환불계좌주명
			Else
				m_delivery_co_nm = server.URLEncode(Request.Form("DeliveryCoNm"))
				m_register_name = server.URLEncode(Request.Form("RegisterName"))
				m_buyeraddr = server.URLEncode(Request.Form("BuyerAddr"))
				m_reject_reason = server.URLEncode(Request.Form("RejectReason"))
				m_refund_name = server.URLEncode(Request.Form("RefundName"))
			END If

			m_confirm_mail = Request.Form("ConfirmMail")			' 구매결정 메일 발송 여부
			m_refund_account = Request.Form("RefundAccount")		' 환불계좌번호
			m_refund_bank_code = Request.Form("RefundBankCode")		' 환불계좌은행코드

			m_send_data = "ReqType="&m_reqtype&"&DeliveryCoNm="&m_delivery_co_nm&"&InvoiceNum="&m_invoice_num& _
							"&RegisterName="&m_register_name&"&BuyerAddr="&m_buyeraddr& _
							"&MID="&m_mid&"&PayMethod="&m_paymethod& _
							"&UserIP="&m_userip&"&MallIP="&m_mallip&"&BuyerAuthNum="&m_buyerauthnum& _
							"&ConfirmMail="&m_confirm_mail& _
							"&RejectReason="&m_reject_reason& "&RefundAccount="&m_refund_account& _
							"&RefundBankCode="&m_refund_bank_code& "&RefundName="&m_refund_name& _
							"&EncodeKey="&server.URLEncode(m_encodekey)&"&TID="&m_tid& _
							"&CharSet="&m_charset&"&LiteType="&m_litetype

			m_log.write_log "TID : " & m_tid

		END IF

		' 2018-01-05
		If m_debug = "true" Then
			Dim data_array, item_array, item_value
			data_array = Split(m_send_data, "&")
			count = UBound(data_array)
			For i = 0 To count
				item_array = Split(data_array(i), "=")
				If UBound(item_array) = 1 Then
					If (item_array(0) <> "CardNo" And item_array(0) <> "CardNum" And item_array(0) <> "GiftStampNo") Then
						m_log.write_log "> " & item_array(0) & " = " & unescape(URLDecode(item_array(1)))
					End If
				End If
			Next
		End If

		f_logString	= "MakeMSG OK"
		m_log.write_log f_logString

	End Function


	Public  Function LiteRequest(req_type, send_data)

		Dim xmlRequest, Field_Value, httpcall_url

		httpcall_url	= "https://web.nicepay.co.kr/lite/" & req_type

		f_logString	=	"Connect NICE WEB"
		m_log.write_log f_logString

		SET xmlRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		'response.write "전문 통신 시작 1 : "& Timer & "[" &Timer-m_start_time& "]"& "<br>"
		lngResolveTimeout	=	2000
		lngConnectTimeout	=	2000
		lngSendTimeout		=	5000
		lngReceiveTimeout	=	25000
		'lngReceiveTimeout	=	1

		xmlRequest.SetTimeouts  lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout

		xmlRequest.open "POST",httpcall_url, True ' 비동기 방식 적용 : 동기방식은 다음과 같이 xmlRequest.open "POST",httpcall_url, False
		xmlRequest.setRequestHeader "Connection", "close"
		xmlRequest.setRequestHeader "Content-Length", Len(send_data)
		xmlRequest.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=EUC-KR"
		'xmlRequest.setRequestHeader "CharSet", "EUC-KR"
		xmlRequest.setOption 0, "EUC-KR"
		xmlRequest.setOption 2, 13056

		On Error Resume Next

		xmlRequest.Send send_data

		f_logString	=	"Send OK"
		m_log.write_log f_logString

		Do while xmlRequest.readyState <> 4

			xmlRequest.waitForResponse 25000

			IF Err.Number <> 0 then

				r_ResultMsg	 =	"결제처리 지연 - " & Err.Description 			'결과내용
				r_ResultCode	 =	"9999"
				SET xmlRequest = Nothing

				'로그 기록
				f_logString	=	"Receive fail : " & r_resultmsg
				  m_log.write_log f_logString

				m_status = 0
				Err.Clear

				'망상 취소(결제시에만 망상취소, 취소시에는 적용안됨)
				IF  m_type = "PYO" THEN
					NICENetCancel()
				END IF

				Exit do

			END IF

		Loop

		IF m_status <> 0 then

			f_logString	=	"Receive OK"
			m_log.write_log f_logString
			m_recv_data =	xmlRequest.ResponseText

			' 2018-01-05
			If m_debug = "true" Then
				temp_arry = Split(Trim(Replace(m_recv_data, vbCrLf, "")), "|")
				count = UBound(temp_arry)
				For i = 0 To count
					If (InStr(temp_arry(i), "CardNo") = 0 And InStr(temp_arry(i), "CardNum") = 0 And InStr(temp_arry(i), "GiftStampNo") = 0) Then
						m_log.write_log "< " & Replace(temp_arry(i), Chr(10), "")
					End If
				Next
			End If

			Result_Parsing(m_recv_data)

			m_log.write_log "Result TID : " & r_TID

			SET xmlRequest = Nothing

		END IF

	End Function


	Public Function NICENetCancel()

		On Error Resume Next

		'response.write "망상취소  통신 시작  : "& Timer & "[" &Timer-m_start_time& "]"& "<br>"
		Dim xmlNetRequest, Field_Value, httpcall_url, send_data
		f_nc_msg = "Net cancel"

		' 20180410 가맹점 모듈 정보 추가 (신규 필드 추가 없이 전문공통헤더의 ErrorMsg 필드를 이용하기로 함)

		send_data = "MID=" & m_mid & "&TID=" & Request.Form("TID") & "&CancelPwd="&m_netcancelpwd&"&CancelAmt="&m_netcancelamt&"&CancelMsg="&f_nc_msg&"&ErrorMsg="&m_module_info

		httpcall_url	= "https://web.nicepay.co.kr/lite/cancelProcess.jsp"
		f_logString	=	"Net Cancel Start"
		m_log.write_log f_logString
		f_logString	=	"Net Cancel Msg OK"
		m_log.write_log f_logString
		SET xmlNetRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")

		lngResolveTimeout	=	2000
		lngConnectTimeout	=	2000
		lngSendTimeout		=	5000
		lngReceiveTimeout	=	25000
		xmlNetRequest.SetTimeouts  lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout

		xmlNetRequest.open "POST",httpcall_url, True
		xmlNetRequest.setRequestHeader "Connection", "close"
		xmlNetRequest.setRequestHeader "Content-Length", Len(send_data)
		xmlNetRequest.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=EUC-KR"

		On Error Resume Next

		xmlNetRequest.Send send_data

		Do while xmlNetRequest.readyState <> 4

			'Response.Write "wait time = " & date & "status : "& xmlRequest.readyState&"<br>"
			'Response.flush
			xmlNetRequest.waitForResponse 25000

			if Err.Number <> 0 then

				'로그 기록
				f_logString	=	"Net Cancel Send & Receive fail : " & Err.Description
				m_log.write_log f_logString

				SET xmlNetRequest = Nothing

				m_status = 0
				Err.Clear

				f_logString	=	"Net Cancel Fail"
				m_log.write_log f_logString

				Exit do

			END IF

		Loop

		f_logString	=	"Net Cancel OK"
		m_log.write_log f_logString

		m_netcancel_recv_data =	xmlNetRequest.ResponseText

		SET xmlNetRequest = Nothing

	End Function


	Public  sub Result_Parsing(DataResultXML)

		temp_arry = Split(DataResultXML ,"|")
		count = UBound(temp_arry)

		Dim a,b

		For i =0 To count
			sub_array = split( temp_arry(i),"=")
			a = trim(sub_array(0))
			b = trim(sub_array(1))

			Select Case a

				Case "ResultCode"
					r_ResultCode = b
				Case "ResultMsg"
					r_ResultMsg = b
				Case "ErrorMsg"
					r_ErrorMsg = b
				Case "ErrorCD"
					r_ErrorCD = b
				Case "AuthDate"
					r_AuthDate = b
				Case "AuthCode"
					r_AuthCode = b
				Case "BuyerName"
					r_BuyerName = b
				Case "GoodsName"
					r_GoodsName = b
				Case "Moid"
					r_Moid = b
				Case "PayMethod"
					r_PayMethod = b
				Case "TID"
					r_TID = b
				Case "Amt"
					r_Amt = b
				Case "CardCode"
					r_CardCode = b
				Case "CardName"
					r_CardName = b
				Case "CardNo"
					r_CardNo = b
				Case "CardQuota"
					r_CardQuota = b
				Case "CardInterest"
					r_CardInterest = b
				Case "BankCode"
					r_BankCode = b
				Case "BankName"
					r_BankName = b
				Case "RcptType"
					r_RcptType = b
				Case "RcptTID"
					r_RcptTID = b
				Case "RcptAuthCode"
					r_RcptAuthCode = b
				Case "Carrier"
					r_Carrier = b
				Case "DstAddr"
					r_DstAddr = b
				Case "VbankBankCode"
					r_VbankBankCode = b
				Case "VbankBankName"
					r_VbankBankName = b
				Case "VbankNum"
					r_VbankNum = b
				Case "VbankExpDate"
					r_VbankExpDate = b
				Case "VbankAccountName"
					r_VbankAccountName = b
				Case "CancelAmt"
					r_CancelAmt = b
				Case "CancelTime"
					r_CancelTime =b
				Case "CancelDate"
					r_CancelDate =b
				Case "processDate"
					r_processDate =b
				Case "processTime"
					r_processTime =b

			End Select

		Next

		m_log.write_log "PARSE RESULT OK"

	END sub

	'****************************************************************************************
	'*
	'*  형 식 : Function
	'*  정 의 : Public Function URLDecode(URLStr)
	'*  설 명 : URLStr 인자로 입력받은 문자열을 URLDecoding 한다.
	'*  작 성 : 송원석
	'*  날 짜 : 2001.12.03
	'*
	'****************************************************************************************
	Public Function URLDecode(URLStr)

		Dim sURL                '** 입력받은 URL 문자열
		Dim sBuffer             '** Decoding 중의 URL 을 담을 Buffer 문자열
		Dim cChar               '** URL 문자열 중의 현재 Index 의 문자

		Dim Index

	On Error Resume Next

		Err.Clear
		sURL = Trim(URLStr)     '** URL 문자열을 얻는다.
		sBuffer = ""            '** 임시 Buffer 용 문자열 변수 초기화.

		'******************************************************
		'* URL Decoding 작업
		'******************************************************

		Index = 1

		Do While Index <= Len(sURL)

			cChar = Mid(sURL, Index, 1)

			If cChar = "+" Then

				'** '+' 문자 :: ' ' 로 대체하여 Buffer 문자열에 추가한다.
				sBuffer = sBuffer & " "
				Index = Index + 1

			ElseIf cChar = "%" Then

				'** '%' 문자 :: Decoding 하여 Buffer 문자열에 추가한다.
				cChar = Mid(sURL, Index + 1, 2)

				If CInt("&H" & cChar) < &H80 Then

					'** 일반 ASCII 문자
					sBuffer = sBuffer & Chr(CInt("&H" & cChar))
					Index = Index + 3

				Else

					'** 2 Byte 한글 문자
					cChar = Replace(Mid(sURL, Index + 1, 5), "%", "")
					sBuffer = sBuffer & Chr(CInt("&H" & cChar))
					Index = Index + 6

				End If

			Else

				'** 그 외의 일반 문자들 :: Buffer 문자열에 추가한다.
				sBuffer = sBuffer & cChar
				Index = Index + 1

			End If

		Loop

		'** Error 처리
		If Err.Number > 0 Then

			URLDecode = URLStr
			Exit Function

		End If

		'** 결과를 리턴한다.
		URLDecode = sBuffer

		Exit Function

	End Function

End Class

%>
