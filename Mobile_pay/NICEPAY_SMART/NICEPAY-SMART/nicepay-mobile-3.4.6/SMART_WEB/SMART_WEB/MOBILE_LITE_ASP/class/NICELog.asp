<%

Class clssNICELog

	public m_type
	public m_pgid
	public m_mid
	public m_debug

	private m_logdir
	private m_LOG_BASE_DIR

	private sub Class_Initialize()
			'클래스 초화 시 해야할 작업

	End Sub

	private sub Class_Terminate()
			'클래스 종료

	End Sub

	Function LoggingInitialize(temp_dir)

		m_LOG_BASE_DIR = temp_dir
		m_logdir = m_LOG_BASE_DIR & "\log\"

		log_folder_create(m_LOG_BASE_DIR)
		log_folder_create(m_LOG_BASE_DIR & "\log")

	End Function

	Function log_folder_create(folder_name)	'디렉토리 생성

		set fso = Server.CreateObject("Scripting.FileSystemObject")
		If Not fso.FolderExists(folder_name) Then
			CreateFolderRecursive fso, folder_name
		end if
		set fso = nothing

	End Function

	Function CreateFolderRecursive(fso, FullPath)

		Dim arr, dir, path

		arr = split(FullPath, "\")
		path = ""
		For Each dir In arr
			If path <> "" Then path = path & "\"
			path = path & dir
			If fso.FolderExists(path) = False Then fso.CreateFolder(path)
		Next

	End Function

	Function write_log(v_value)	'로그 파일 Create  및 Write

		dim ObjFSO, ObjTS, v_logfilename

		f_tempDate = year(now) & right("0" & month(now),2) & right("0" & day(now),2)
		f_logfilename = "NICELite_" & m_type &"_"& m_mid &"_"& f_tempDate & ".log"

		set ObjFSO = Server.CreateObject("Scripting.FileSystemObject")
		set ObjTS = ObjFSO.OpenTextFile(m_logdir & f_logfilename, 8, true)
		ObjTS.WriteLine "[" & makeStrTime() & "]" & "<" & m_pgid & ">  " & v_value
		set ObjTS = nothing
		set objFSO = nothing

	End Function

	Public Function makeStrTime()	'로그 내용중에 각 단계별 시각 표시

		yy = year(now)
		mm = right("0" & month(now),2)
		dd = right("0" & day(now),2)
		hh = right("0" & hour(now),2)
		mi = right("0" & minute(now),2)
		ss = right("0" & second(now),2)
		ms = right("000" & (timer * 1000) Mod 1000, 3)

		makeStrTime	=	yy &"-"& mm &"-"& dd &" "& hh &":"& mi &":"& ss &"."& ms

	End Function

End Class

%>
