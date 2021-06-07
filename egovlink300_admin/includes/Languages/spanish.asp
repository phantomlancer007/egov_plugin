<%

'This line gets added to other files
'<!-- #include virtual="boardsite/includes/language.asp" //-->

'These values can be changed in the custom\lang file

Dim   langBackToCommittee	
Dim   landBSCommittees		
Dim   langCommittee		
Dim   langCommittees		
Dim   langNewCommittee		
Dim   langTabCommittees		
Dim   lanAdminCommittee		
Dim   lanRegisterCommitteeTitle 
Dim   langDiaplyCommittee	
Dim   langRegisterCommitteeTitle
Dim   langInsertCommittee2	
Dim   langInsertCommittee3	
Dim   langInsertCommittee4	
Dim   langAdminCommitteeAdded	
Dim   langAdminCommittee
Dim   langBSAdmin	



'Language Constants

Const langAbstain = 		"Abstenerse"
Const langAddDoc = 		"Nuevo Documento"
Const langAddFolder = 		"Nueva Carpeta"
Const langAddHelp = 		"A�adir Ayuda"
Const langAgendaInfo		= "~Agenda Information~"	'********
Const langAddAgenda			= "Add Agenda Information"	'********
Const langAdmin = 		"Administraci�n"
Const langAlertSelect = 	"Por favor selecciona texto en azul!"
Const langAll = 		"Todo" 	' Context is Searching Users, Groups or All in address book
Const langAnnouncementLinks = 	"V�nculos de Avisos"
Const langAnnouncement = 	"Anuncio"
Const langAnnouncements = 	"Anuncios"
Const langApprovalRating = 	"Grado de Aprovaci�n"
Const langBackToVotingPoll =	"Volver a la lista de Encuestas"
Const langBackToCalendar = 	"Volver al Calendario"
      langBackToCommittee	= "~Back To Committee List~"	'******
Const langBackToEventList =	"Volver a la lista de Eventos"
Const langBackToGroupsList = 	"Volver a la lista de Grupos"
Const langBackToInbox = 	"Volver a la Bandeja de Entrada"
Const langBackToStart = 	"Volver a la p�gina de Inicio"
Const langBackToTopic = 	"Volver al T�pico"
Const langBackToTopicsList = 	"Volver a la lista de T�picos"
Const langBSAddressBook = 	"BoardSite {Libro de Direcciones}"
Const langBSAnnouncements = 	"BoardSite {Anuncios}"
      landBSCommittees = 	"BoardSite {Comit�s}"
Const langBSDiscussions = 	"BoardSite {Discusiones}"
Const langBSDocuments = 	"BoardSite {Documentos}"
Const langBSEventsCalendar =  	"BoardSite {Calendario de Eventos}"
Const langBSEvents =  		"BoardSite {Eventos}"
Const langBSFavorites =		"BoardSite {Favoritos}"
Const langBSHome = 		"BoardSite {Entrada}"
Const langBSLogin = 		"BoardSite Conexi�n"
Const langBSMessages = 		"BoardSite {Mensajes}"
Const langBSMeetings		= "~BoardSite {Meetings}~" 	'****** 
Const langCancel = 		"Cancelar"
Const langCc =			"Cc"
Const langChoose = 		"Selecciona..."
Const langCollapseMenu = 	"Contraer Menu"
      langCommittee = 		"Comit�"
      langCommittees = 		"Comit�s"
Const langCompose = 		"Redactar"
Const langContact = 		"Contacto" 	'Context:  This is a user who is not a member, merely a contact
Const langConfirmDeleteDiscussion = 	"Ejecutando esta acci�n borrar� todos los temas y mensajes asociados con este grupo. Est�s seguro de querer continuar?"
Const langConfirmDeleteTopic = 	"Ejecutando esta acci�n tambien borrar� todos los mensajes asociados con este tema. Estas seguro de querer continuar?"
Const langCopyright = 		"Copyright &copy; 2002, <i>ec link, inc.</i> Todos los Derechos Reservados."
Const langCreate = 		"Crear"
Const langCreator = 		"Autor"
Const langDate = 		"Fecha"
Const langDateTime = 		"Fecha/Tiempo Date/Time"
Const langDay1 =		"Dom"
Const langDay2 =		"Lun"
Const langDay3 =		"Mar"
Const langDay4 =		"Mie"
Const langDay5 =		"Jue"
Const langDay6 =		"Vie"
Const langDay7 =		"Sab"
Const langDays = 		"D�as"
Const langDelete = 		"Eliminar"
Const langDescription = 	"Descripcion"
Const langDetails = 		"Detalles"
Const langDirectory = 		"Carpeta"
Const langDiscussion = 		"Discusi�n"
Const langDiscussions = 	"Discusiones"
Const langDiscussionGroup = 	"Grupo de Discusi�n"
Const langDiscussionGroups = 	"Grupos de Discusi�n"
Const langDiscussionLinks = 	"V�nculos de Discusi�n"
Const langDocuments = 		"Documentos"
Const langDocumentsHome = 	"Inicio Documentos"
Const langDrafts = 		"Borradores"
Const langDuration = 		"Duraci�n"
Const langEditAnnouncements =	"Editar Anuncios"
Const langEditEvents =		"Editar Eventos"
Const langEditFavorites =	"Editar Favoritos"
Const langEditMembers = 	"Editar Miembros"
Const langEntries = 		"Entradas"
Const langErrorRetrievingTopic = 	"Error al consultar los mensajes del tema."
Const langEvent = 		"Evento"
Const langEventLinks = 		"V�nculos del Evento"
Const langEvents = 		"Eventos"
Const langFavoriteLinks = 	"V�nculos Favoritos"
Const langFavorites = 		"Favoritos"
Const langForgotPass = 		"Has olvidado tu contrase�a?"
Const langForward = 		"Reenviar"
Const langFrom = 		"De"
Const langGo =			"Ir"
Const langGoBack = 		"Volver"
Const langGroup = 		"Grupo"
Const langGroups = 		"Grupos"
Const langIn = 			"en" 	'context:  Message 1 of 10 in discussion
Const langInbox = 		"Bandeja de Entrada"
Const langInvalid = 		"Usuario o contrase�a invalido"
Const langHours = 		"Horas"
Const langLastReply =		"�ltima Respuesta"
Const langLocation = 		"Location"
Const langLogMeAuto = 		"Iniciar autom�ticamente"
Const langLogIn	=		"Iniciar sesi�n"
Const langLogOut = 		"Cerrar sesi�n"
Const langMember = 		"Miembro"
Const langMessage = 		"Mensaje"
Const langMessageBoxes = 	"Mensajes" ' I DON�T REALLY KNOW THE EXACT MEANING OF "MESSAGE BOXES" THE LITERAL TRANSLATION SOUNDS HOOOOORRIBLE,  I DECIDED TO PUT JUST MESSAGES, IF I AM WRONG I AM SORRY!
Const langMessageDeleted = 	"El Mensaje ha sido borrado."
Const langMessageLinks = 	"V�nculos del Mensaje"
Const langMessages = 		"Mensajes"
Const langMessageView = 	"Ver Mensaje"
Const langMinutes = 		"Minutos"
Const langMonth01 = 		"Enero"
Const langMonth02 = 		"Febrero"
Const langMonth03 = 		"Marzo"
Const langMonth04 = 		"Abril"
Const langMonth05 = 		"Mayo"
Const langMonth06 = 		"Junio"
Const langMonth07 = 		"Julio"
Const langMonth08 = 		"Agosto"
Const langMonth09 = 		"Septiembre"
Const langMonth10 = 		"Octubre"
Const langMonth11 = 		"Noviembre"
Const langMonth12 = 		"Diciembre"
Const langMore = 		"M�s"
Const langName = 		"Nombre"
Const langNeedsDiscussion = 	"Necesita Discusi�n"
Const langNew = 		"Nuevo"
Const langNewAnnouncement = 	"Nuevo Anuncio"
      langNewCommittee = 	"Nuevo Comit�"
Const langNewContact = 		"Nuevo Contacto"
Const langNewDiscussion = 	"Nueva Discusi�n"
Const langNewDiscussionGroup =	"Nuevo Grupo de Discusi�n"
Const langNewDiscussions = 	"Nuevas Discusiones"
Const langNewEvent = 		"Nuevo Evento"
Const langNewFavorite =		"Nuevo Favorito"
Const langNewIssues = 		"nuevas encuestas para votar"	'context:  You have 2 new issues to vote on.
Const langMeetingLinks		= "Vinculos Reuniones"	'******
Const langNewMeeting = 		"Nueva Reuni�n"
Const langNewMeetings = 	"Nuevas Reuniones"
Const langNewMember = 		"Nuevo Miembro"
Const langNewMessage = 		"Nuevo Mensaje"
Const langNewMessages = 	"Mensajes Nuevos"
Const langNewPoll =		"Nueva Encuesta"
Const langNewTopic =		"Nuevo Tema"
Const langNewVote = 		"Nuevo Voto"
Const langNewVotes = 		"Nuevos Votos"
Const langNext =		"Siguientes"
Const langNextMessage = 	"Siguiente Mensaje"
Const langNextMonth = 		"Siguiente Mes"
Const langNextPoll = 		"Siguiente Encuesta"
Const langNo = 			"No"
Const langNoEntriesFound = 	"No se ha encontrado ning�n resultado"
Const langNoMeetingsFound	= "No new Meetings"	'******
Const langNoDrafts = 		"Ning�n borrador del Mensaje."
Const langNoNewMessages = 	"Ning�n Mensaje Nuevo."
Const langNoSentMessages = 	"Ning�n Mensaje Enviado."
Const langNoTopics = 		"No hay ning�n tema para este grupo de discusi�n."
Const langOf = 			"de" 	'context:  Message 1 of 10 in discussion
Const langPassword = 		"Contrase�a:"
Const langPersonalFavorites = "~Personal Favorites~"	'******
Const langPollSubject = 	"Tema de Encuesta"
Const langPrev = 		"Previos"
Const langPreviousMonth = 	"Previo Mes"
Const langPrevMessage = 	"Previo Mensaje"
Const langPrevPoll = 		"Previa Encuesta"
Const langPrintCurrDoc = 	"Imprimia Documento Actual"
Const langQuestion = 		"Pregunta"
Const langQuickLinks = 		"V�nculos r�pidos"
Const langRe = 			"Re:"	'context:  Prefix to the subject of a reply
Const langFw                = "~Fw:~" '***********
Const langRefreshMenu = 	"Actualizar Men�"
Const langReplies = 		"Respuestas"
Const langReply = 		"Responder"
Const langReplyAll = 		"Responder Todo"
Const langReplyToMessage = 	"Responder al Mensaje"
Const langResponses = 		"Respuestas"
Const langSaveCurrDoc = 	"Salvar Documento Actual"
Const langSearchAddressBook = 	"Buscar en el Libro de Direcciones"
Const langSearchDiscussions = 	"Buscar Discusiones"
Const langSearchDocuments = 	"Buscar Documentos"
Const langSearchMessages = 	"Buscar Mensajes"
Const langSendReply = 		"Enviar Respuesta"
Const langSent = 		"Enviado"
Const langSentMail = 		"Enviar Correo"
Const langSentMessages = 	"Mensajes Enviados"
Const langStartTime = 		"Hora de Inicio"
Const langStartedBy =		"Iniciado por"
Const langStatus = 		"Estado"
Const langSubject = 		"Asunto"
Const langSubmitVote = 		"Enviar Voto"
Const langSubmitRegister	= "~Register Now~"	'******
Const langSummary = 		"Resumen"
Const langTabAdmin		= "~Admin~"	'******
      langTabCommittees = 	"Comit�s"
Const langTabDiscussions =	"Discusiones"
Const langTabDocuments = 	"Documentos"
Const langTabHome = 		"Entrada"
Const langTabMeetings = 	"Reuniones"
Const langTabMessages = 	"Mensajes"
Const langTabVoting = 		"Votaci�n"
Const langThereAre = 		"Hay" 	'Context:  There Are 4 New Documents.
Const langThreadedView = 	"Vista en rosca" '"Threaded View" DOUBLE-CHECK THIS ONE AS I KNOW THE WORD IN ENGLISH AND NOT IN SPANISH! what a bad lation guy isn�t it??????????
Const langTime =		"Hora"
Const langTo = 			"Para"
Const langTopic = 		"Tema"
Const langTotal = 		"Total"
Const langType =		"Tipo"
Const langTypeEmail = 		"Email"
Const langTypeFTP = 		"Sitio FTP"
Const langTypeNetwork = 	"Archivo de Red"
Const langTypeWeb = 		"Web Site"
Const langTopicNewFirstMessage = 	"Tema: Nuevo (Primer Mensaje)"
Const langUpdate = 		"Actualizar"
Const langUpdateAnnouncement = 	"Actualizar Anuncio"
Const langUpdateEvent = 	"Actualizar Evento"
Const langUpdateFavorite =	"Actualizar Favoritos"
Const langURL =			"URL"
Const langUsers =		"Usuarios"
Const langUserName = 		"Nombre de Usuario:"
Const langVoted = 		"Votado"
Const langVoting = 		"Votaci�n"
Const langVotingPoll = 		"Votaci�n de la Encuesta"
Const langWeeks = 		"Semanas"
Const langWelcomeBack = 	"Bienvenido de nuevo "
Const langYes = 		"Si"
Const langYouHave = 		"Tienes" 	'context:  You have x new messages
      lanAdminCommittee		= "~Manage Committees~"
const lanRegister_requred	= "~is required~"
      lanRegisterCommitteeTitle = "~Register a new Committee~"
const langFirstname			= "~First Name~"
const langLastName			= "~LastName~"
const langMiddleInitial		= "~Middle Initial~"
const langNickname			= "~NickName~"
const langOrganization		= "~Organization~"
const langcompanyname		= "~Company Name~"
const langBirthday			= "~Birthday~"
const langWebPage			= "~Web Page URL~"
const langFaxNumber			= "~Fax Number~"
const langHomeAddress		= "~Home Address~"
const langBusinessAddress	= "~Business Address~"
const langHomePhone			= "~Home Phone~"
const langBusinessPhone		= "~Business Phone~"
const langMobileNumber		= "~Mobile Number~"
const langPagerNumber		= "~Pager Number"
const langdateformat		= "~(mm/dd/yy)~"
const langDiaplyMember		= "~Display Members~"
const langDiaplyContact		= "~Display Contacts~"
      langDiaplyCommittee	= "~Display Committees~"
const langJobTitle			= "~Job Title~"
      langRegisterCommitteeTitle= "~Create a new committee~"
const langDepartment		= "~Department~"
const langRegisterUserTitle	= "~Create a new user~"
const langInsertDatabaseError="~Some error with database happens, please report to administrator~"
      langInsertCommittee2	= "~No Committee Name~"
      langInsertCommittee3	= "~Committee name is taken, please choose a new username, and try again~"
      langInsertCommittee4	= "~Successfully create the committee~"
const langInsertNormalUser1	= "~No Firstname~"
const langInsertNormalUser2	= "~No Last name~"
const langInsertNormalUser3	= "~No password~"
const langInsertNormalUser4	= "~No username~"
const langInsertNormalUser5 = "~Username is taken, please choose a new username, and try again~"
const langInsertNormalUser6	= "~Successfully create the useraccount~"
const langInsertNormalUser7	= "~Add more User self-defined Properties~"
const langRegisterContactTitle= "~Create a new contact~"
const langAdminUpdateproperty= "~Update property~"
const langAdminPropertyAdded= "~Property added~"
const langAdminUserExtendedTitle= "~Manager User Extended property~"
const langAdminCloseWindow	= "~Close Window~"
const langAdminNewProperty	= "~New property~"
const langAdminAllProperty	= "~All properties~"
fields_description_extended	= array("~Extended ID~","~User ID~","~Property~","~Value~","~Added Time~")
fields_description_committee=array("~GroupID~","~Organizatioin ID~","~GroupName~","~Description~","~Added Time~")
      langAdminCommitteeAdded="~Committee Added~"
      langAdminCommittee	= "~Manage Committee~"
const langManageCommitteeMember1= "~Existing Members~"
const langManageCommitteeMember2= "~Available Members~"
Const langAddMeeting		= "~Add Meeting Information~"
Const langUpdateMeeting		= "~Update Meeting Information~"
Const langUpdateAgenda		= "~Update Agenda Information~"
Const langMeetingNew		= "~Meeting: New~"
Const langMeetingView		= "~Meeting: View~"
Const langMeetingChanges	= "~Meeting: Changes~"
Const langBack2MeetingsList = "~Back To Meetings List~"
Const langEnterEditGenInfo	= "~Enter/Edit General Information~"
Const langMeetingTopic		= "~Topic:~"
Const langMeetingWhen		= "~When:~"
Const langMeetingWhere		= "~Where:~"
Const langReqBy				= "~Requested By:~"
Const langMeetingSummary	= "~Meeting Summary:~"
Const langAM				= "~AM~"
Const langPM				= "~PM~"
const langAdminPermission   = "~Manage the permissions~"
Const langViewConfAtt		= "~View Confirmed Attendees~"
Const langEditMeeting		= "~Edit Meeting~"
Const langGeneralInfo		= "~General Information~"
Const langAgendaSort		= "~Serial No:~"
Const langAgendaDesc		= "~Agenda Description~"
Const langAgendaSub			= "~Agenda Subject~"
Const langAdminLinks        = "Vinculos Administration"
const langSendMsg = "Enviar Mensaje"
const langSaveDraft = "Salvar Borrador"
const langSentMailTop = "Mensajes: Correo Enviado"
const langNewDocTop = "Nuevos"

'Used with timeout popup window
const langSessionTimeout = "~Session Timeout~" '*************
const langOK             = "~OK~" '*************
const langWillBeLoggedOff= "~You will be logged off in 5 minutes due to inactivity.  Do you want to remain logged on?~" '*************
const langBeenLoggedOff  = "~You have been logged off due to inactivity.~" '*************

const langOriginalMessage= "~Original Message~" '**********



%>