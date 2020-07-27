/* $Id: valida.js,v 1.23 2007/11/13 00:00:37 javier Exp $ */
<!-- // valida.js
     // Script para validar formatos
     // Para incluirlo, deberá escribir en el encabezado de su página
     // <SCRIPT LANGUAGE="JavaScript" SRC="valida.js">
     // ...
     // </SCRIPT>

// Checa si es Netscape 4.0 o Internet Exploder 4.0
n = (document.layers) ? 1:0;
ie = (document.all) ? 1:0;

function init() {
	if (n) block = document.blockDiv;
	if (ie) block = blockDiv.style;
}

var message = "";
var more_message = "";
var showmsg = false;
var language = "spanish";
var dateFormat = "british"; 
var formList = new Object();
var formValidationTimeout = 1000;
var currentInput = null;
var inlineValEnabled = false;

function inline_form_validate (currentForm){
	   isValid = true;
	   
	   // form validation only works on firefox
	   try {
			 for (i in currentForm.elements){
				    if (currentForm.elements[i].name == currentForm.currentElement)
						  break;

				    if (inline_chk (currentForm.elements[i].form, currentForm.elements[i].name)){
						  currentForm.elements[i].style.backgroundColor = '#eefdff';
						  currentForm.elements[i].style.color = 'black';
				    } else {
						  currentForm.elements[i].style.backgroundColor = 'red';
						  currentForm.elements[i].style.color = 'white';
						  isValid = false;
				    }
			 }
	   } catch (err) {}
	   
	   return isValid;
}

function inline_validation (){
	   isValid = true;
	   if (!(inlineValEnabled))
			 return null;
	   
	   for (form in formList)
			 if (formList[form].nodeName == 'FORM'){
				    var currentForm = formList[form];

				    inline_chk (currentForm, currentForm.currentElement);

				    // form validation only works on firefox
				    try {
						  for (i in currentForm.elements){
								if (currentForm.elements[i].name == currentForm.currentElement)
									   break;

								if (inline_chk (currentForm.elements[i].form, currentForm.elements[i].name)){
									   currentForm.elements[i].style.backgroundColor = '#eefdff';
									   currentForm.elements[i].style.color = 'black';
								} else {
									   currentForm.elements[i].style.backgroundColor = 'red';
									   currentForm.elements[i].style.color = 'white';
									   isValid = false;
								}
						  }
				    } catch (err) { }
			 }
	   return isValid;
	   
}

function automaticValidation(){
	   if (currentInput){
			 inline_chk (currentInput.form, currentInput.name);
			 setTimeout("automaticValidation();", formValidationTimeout)
	   }
}

function inline_chk (Form, ElementName){
	     var isValid = true;
	     var msg = document.getElementById('msg_' + ElementName);
		if (msg){
			   msg.innerHTML = '';
			   msg.style.visibility = 'hidden';
		}
		
	   	for (var i = 0; i < Form.length; i++) {
			   var chk_msg = null;
			   var name = Form.elements[i].name;
			   var prefix = name.substring(0,2);
			   
			   if (prefix + ElementName == name && Form.elements[i].type == 'hidden'){

					 switch (prefix){
					 case 'r_' :
						    chk_msg = r_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'i_' :
						    chk_msg = i_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'd_' :
						    chk_msg = d_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'e_' :
						    chk_msg = e_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'p_' :
						    chk_msg = p_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'o_' :
						    chk_msg = o_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'a_' :
						    chk_msg = a_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'w_' :
						    chk_msg = w_chk(Form,Form.length,ElementName,i);
						    break;						    
					 case 'm_' :
						    chk_msg = m_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'z_' :
						    chk_msg = z_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'h_' :
						    chk_msg = h_chk(Form,Form.length,ElementName,i);
						    break;
					 case 'c_' :
						    chk_msg = c_chk(Form,Form.length,ElementName,i);
						    break;
                                         case 'x_' :
                                                    chk_msg = x_chk(Form,Form.length,ElementName,i);
                                                    break;                                          
					 }

 					 if (chk_msg){
						    isValid = false;
						    if (msg){
								  msg.innerHTML += Form.elements[i].value + '<br>';
								  msg.style.visibility = 'visible';
						    }
 					 }
			   }
		}
		return (isValid?true:false);
}
function onFocusValidateField (Input){
	   
	   if (!(Input.form.name in formList))
			 formList[Input.form.name] = Input.form;	   
 	   formList[Input.form.name]['currentElement'] = Input.name;

	   inline_validation();
	   
	   Input.style.backgroundColor = '#fffff0';
	   Input.style.color = 'black';
	   inline_chk (Input.form, Input.name);
	   currentInput = Input;
	   setTimeout("automaticValidation();", formValidationTimeout)
}
function onBlurValidateField (Input){
	   currentInput = null;
	   if (inline_chk (Input.form, Input.name)){
			 Input.style.backgroundColor = '#eefdff';
			 Input.style.color = 'black';
	   } else {
			 Input.style.backgroundColor = 'red';
			 Input.style.color = 'white';
	   }
}
function chk(form, vSubmits, submit_form) {
	message = "";
	more_message = "";
	showmsg = false;
	if (typeof submit_form == "undefined") {
		   submit_form = true;
	}
	
	no_inputs = form.length - vSubmits; // Todos los elementos de la forma menos los submits
//	alert(no_inputs);

	for (var i = 0; i < no_inputs; i++) {
		var prefix = form.elements[i].name
		prefix = prefix.substring(0,2)  // Extracts prefix
		var fieldname = form.elements[i].name
		fieldname = fieldname.substring(2) // Extracts fieldname

		if (prefix == "r_") { // Required
			more_message = r_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "i_") { // Integer
			more_message = i_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "d_") { // Date
			more_message = d_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "e_") { // E-Mail
			more_message = e_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "p_") { // P-Check
			more_message = p_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "o_") { // O-Check
			more_message = o_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "a_") { // Alphanumeric characters
			more_message = a_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "w_") { // Alphabetic characters
			more_message = w_chk(form,no_inputs,fieldname,i)
		} else			   
		if (prefix == "m_") { // Money
			more_message = m_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "z_") { // Zip code
			more_message = z_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "h_") { // Hour:Minute
			more_message = h_chk(form,no_inputs,fieldname,i)
		} else
		if (prefix == "c_") { // RFC 
			more_message = c_chk(form,no_inputs,fieldname,i)
                } else
                if (prefix == "x_") { // XLS file name 
                        more_message = x_chk(form,no_inputs,fieldname,i)
		}
			
		if (more_message != "") { // There is a more_message, we have to do an action
			if (message == "") {
				message = more_message // Sets the message variable with an adequate value
			} else {
				message = message + "\n" + more_message
			}
			more_message = "" // Clean the more_message variable for the next time
		}
		if (message > "") {
			   showmsg = true;
		}

	} // Fin del for

	if (showmsg) {
		if (language == "spanish") {
			alert("Hay al menos un campo con un error:\n\n" + message + "\n\nCorrijalo(s) y vuelva a enviar la forma")
		} else {
			alert("The following form field(s) were incomplete or incorrect:\n\n" + message + "\n\n Please complete or correct the form and submit again.")
		}
	} else {
		   if (submit_form){
				 form.submit();
		   }
	}

	return !showmsg;
}

// r_chk: check if a field is required
function r_chk(form,no_inputs,fieldname,i) {	   
	   var msg_addition = "";
	   
	   for (var j = 0; j < no_inputs; j++)	{
			 if (form.elements[j].name == fieldname && form.elements[j].value.trim() == "") {
				    msg_addition = form.elements[i].value;
				    break;
			 } else {
				    msg_addition = "";
			 }		
	   }

	   if (!(r_chk_radios(form, fieldname))){
			 msg_addition = form.elements[i].value;
	   }

	   if (!(r_chk_selects(form, fieldname))){
			 msg_addition = form.elements[i].value;
	   }
	   
	   return(msg_addition);
}

// i_chk: check if a field is integer
function i_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break
	}						
		
	var msg_addition = ""
	inputStr = form.elements[j].value.toString()
	if (inputStr == "")	{ // Si está en blanco regresa
		   return(msg_addition)
	} else {
		for (var k = 0; k < inputStr.length; k++) {
			var oneChar = inputStr.charAt(k)
			if (k == 0 && oneChar == "-" || oneChar == ".") {
				continue
			}
			if (oneChar < "0" || oneChar > "9") { // Hay un valor incorrecto, lo reporta
				msg_addition = form.elements[i].value
			}
		}
	}
		return(msg_addition)
}
// c_chk: check if a field is rfc
function c_chk(form,no_inputs,fieldname,i) {
    var msg_addition = "";
    for (var j = 0; j < no_inputs; j++)	{
        if (form.elements[j].name == fieldname){
            var inputStr = form.elements[j].value.toString();
            if (inputStr.length == 13 ) {
                if (!inputStr.search(/^[A-Z,&]{4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]{3}$/mi) == 0) {
                    msg_addition = form.elements[i].value;
                }
            } else { 
                if (!inputStr.search(/^[A-Z,&]{3}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]{3}$/mi) == 0) {
                    msg_addition = form.elements[i].value;
                }
            }
            break;
        }
    }						
    return(msg_addition);
}	

// z_chk: check zip code (Mexican version, please modify according your country)
function z_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break;
	}						
	inputStr = form.elements[j].value;

	for (var k = 0; k < inputStr.length ; k++) {
		if (inputStr.charAt(k) < '0' || inputStr.charAt(k) > '9')
			return(form.elements[i].value);
	}
		if (parseInt(inputStr,10) < 1000 || parseInt(inputStr,10) > 99999 || inputStr.length < 5)
           return(form.elements[i].value);

    return("")
}	

// E_Chk: e-mail check
function e_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break;
	}						

	var msg_addition = "";
	var eMail = form.elements[j].value;

	if (eMail.indexOf ('@', 0) < 0)
		msg_addition = form.elements[i].value;

	return(msg_addition);
}

// P_Chk:  Phone check (Exprofeso para Telmex II)
function p_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break;
	}						

	var msg_addition = "";
	var pValue = form.elements[j].value;

	for (var k = 0; k < pValue.length ; k++) {
		if (pValue.charAt(k) < 0 || pValue.charAt(k) > 9)
			return(form.elements[i].value);
    }

    if (pValue.length < 8)
		msg_addition = form.elements[i].value;

    if (pValue.substring(0,1) == 0)
		msg_addition = form.elements[i].value;

	return(msg_addition);
}

// O_Chk:  Service order check (Exprofeso para Telmex II)
function o_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break;
	}						

	var oValue = form.elements[j].value;

	for (var k = 0; k < oValue.length ; k++) {
		if (oValue.charAt(k) < '0' || oValue.charAt(k) > '9')
			return(form.elements[i].value);
        }

	if (oValue.length < 6)
       return(form.elements[i].value);

    if (parseInt(oValue,10) < 1)
           return(form.elements[i].value);

	return("");
}

// d_chk: date check.
// date must be in MM/DD/YYYY format OR M/D/YYYY or a MIX of the two
// if you set the dateFormat variable to "british" the format will be
// DD/MM/YYYY or D/M/YYYY
function d_chk(form,no_inputs,fieldname,i) {

	for (var j = 0; j < no_inputs; j++) {
		if (form.elements[j].name == fieldname)
			break;
	}
			
	var msg_addition = "";
	var sDate = form.elements[j].value;
	var xError = form.elements[i].value; // El valor del error que se pone en msg_addition
	var isInt = isInteger(sDate);
	var ok = 0;
				 
	if (isInt) { // True
		if ((sDate.length >= 6) && (sDate.length <= 10)) {
			var Slash1Pos = sDate.indexOf("/",0);
			var Slash2Pos = sDate.indexOf("/",Slash1Pos+1);
			if (Slash2Pos > 0) {
				var Month = sDate.substring(0,Slash1Pos);
				var Day = sDate.substring(Slash1Pos+1,Slash2Pos);
				var Year = sDate.substring(Slash2Pos+1);
				if (dateFormat == "british") { // Almost everybody use the day/month/year format, even the british
					var xTmp = Month;
					Month = Day;
					Day = xTmp;
				}

				if (Year > 1900) {
					if (Month >= 1 && Month <= 12) {
						if (Day >= 1) {
							// February
							if (Month == 2) {
								LeapYear = (Year % 4) ? 0 : 1; // Calculates if Year is a Leapyear
								if (LeapYear) {
									if (Day < 30)
										ok = 1;
								} else {
									if (Day < 29)
										ok = 1;
								}
							} // Month == 2
							
							//          Ene           Mar           May           Jul           Aug            Oct            Dec
							if (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 || Month == 12)
                               {
								if (Day < 32)
									ok = 1;
							   } // if (Month ... of 31 days
					//		if (Month == 4 || Month == 6 || Month == 9 || Month == 11) {
                            else
                               {
									if (Day < 31)
										ok = 1;
							   } // if (Month ... of 30 days
						} // if (Day >= 1)
					} // if (Month ...
				} // if (Year ...
			} // if Shlash2Pos > 0
		} // if sDate.lenght > ...
	} // if IsInt

	if (ok) {
            return("");
        } else {
            if (sDate == "") {
                return("");
            } else {
                return(xError);
            }
        }
} // d_chk() end

// h_chk: date check.
function h_chk(form,no_inputs,fieldname,i) {

	for (var j = 0; j < no_inputs; j++) {
		if (form.elements[j].name == fieldname)
			break;
	}
			
	var msg_addition = "";
	var sHour = form.elements[j].value;
	var xError = form.elements[i].value; // El valor del error que se pone en msg_addition
	var isInt = isIntegerInHour(sHour);
	var ok = 0;
				 
	if (isInt) { // True
		if ((sHour.length >= 3) && (sHour.length <= 5)) {
			var PointPos = sHour.indexOf(":",0);
			if (PointPos > 0) {
				var Hour = sHour.substring(0,PointPos);
				var Minute = sHour.substring(PointPos+1);
				if (Hour >= 0 && Hour <= 23) {
					if (Minute >= 0 && Minute <= 59) {
                       ok = 1;
                    }
                }
			} // if PointPos > 0
		} // if sHour.lenght > ...
	} // if IsInt

	if(ok || sHour == "")
		return("");
	else
		return(xError);
} // h_chk() end


// isInteger. It really does not check if is 
function isInteger(sDate) {
	var new_msg = 1
	inputStr = sDate.toString()
	for (var j = 0; j < inputStr.length; j++) {
		var oneChar = inputStr.charAt(j)			
		if ((oneChar < "0" || oneChar > "9") && oneChar != "/") {
			new_msg = 0
		}
	}
	return (new_msg)
}
// isIntegerInHour. It really does not check if is 
function isIntegerInHour(sHour) {
	var new_msg = 1
	inputStr = sHour.toString()
	for (var j = 0; j < inputStr.length; j++) {
		var oneChar = inputStr.charAt(j)			
		if ((oneChar < "0" || oneChar > "9") && oneChar != ":") {
			new_msg = 0
		}
	}
	return (new_msg)
}
	
function asc(each_char) {
	var n = 0
	var char_str = charSetStr()
		for (i = 0; i < char_str.length; i++) {
			if (each_char == char_str.substring(i, i+1)) {
				break
			}
		}
	return i + 32
}
		
function charSetStr(){
	var str = ' !"#$%&' + "'" + '()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
	return str;
}

// m_chk: money check
function m_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break;  
	}						

	inputStr = form.elements[j].value.toString();
	for (var k = 0; k < inputStr.length; k++) {
		var oneChar = inputStr.charAt(k);
		if (k == 0 && oneChar == "-" || oneChar == ".") {
			continue;
		}
		if (oneChar < "0" || oneChar > "9") { // If the number gets out range...
			return(form.elements[i].value);
		}
	}
	return("");
}


// w_chk: check if a field is alphabethic (non numeric) (a-zA-Z)
function w_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break
	}						
		
	var msg_addition = ""
	inputStr = form.elements[j].value.toString()
        if (inputStr == "") {
            msg_addition = "";
        } else {
            for (var k = 0; k < inputStr.length; k++) {
                 var oneChar = inputStr.charAt(k)

                 if ((oneChar >= "A" && oneChar <= "Z") ||
                     (oneChar >= "a" && oneChar <= "z") ||
				 (oneChar == " ")) {
                      msg_addition = "";
                 } else {
                     msg_addition = form.elements[i].value;
				 break;
                 }
           }
            if (inputStr.search(/^\s+$/gi) == 0)
				msg_addition = form.elements[i].value;
	}
        return(msg_addition)
}	

// a_chk: check if a field is alphanumeric (a-zA-Z0-9)
function a_chk(form,no_inputs,fieldname,i) {
	for (var j = 0; j < no_inputs; j++)	{
		if (form.elements[j].name == fieldname)
			break
	}						
		
	var msg_addition = ""
	inputStr = form.elements[j].value.toString()
        if (inputStr == "") {
            msg_addition = "";
        } else {
            for (var k = 0; k < inputStr.length; k++) {
                 var oneChar = inputStr.charAt(k)

                 if ((oneChar >= "A" && oneChar <= "Z") ||
                     (oneChar >= "a" && oneChar <= "z") ||
                     (oneChar >= "0" && oneChar <= "9") ||
				 (oneChar == " ")) {
                      msg_addition = "";
                 } else {
                     msg_addition = form.elements[i].value;
				 break;
                 }
           }
            if (inputStr.search(/^\s+$/gi) == 0)
				msg_addition = form.elements[i].value;
	}
        return(msg_addition)
}	

function PopWin(nombre,url,ancho,alto) {
         var WinAux = window.open(url,nombre,"width="+ancho+",height="+alto+ ",menubar=no",true);
         WinAux.creator = self;
         WinAux.focus();
}

function Help_Window(topic) {
    var WinHelp = window.open('/bin/help.pl?keyword='+topic, 'Help', 'toolbar=no,location=no,directories=no,status=no,menubar=no,width=500,height=400,left=100,top=100,scrollbars=yes,resizable=yes');
}

function confirm_submit (msg, url, target) {
	   if (confirm (msg)){
			 if (target == null)
				    document.location = url;
			 else
				    var WinOpen = window.open(url, target);
	   } else {
			 return false;
	   }
}
function confirm_submit_form (msg, form) {
	   if (confirm (msg)){
			 form.submit();
	   } else {
			 return false;
	   }
}

function r_chk_radios(FormElement, FieldName) {
	   if (!(form_has_radios(FormElement, FieldName)))
			 return true;
	   
	   var radio_checked = false;
	   for (var i = 0; i < FormElement.length; i++){
			 if ((FormElement[i].type == 'radio' && FormElement[i].name == FieldName)||
				(FormElement[i].type == 'checkbox' && FormElement[i].name == FieldName)){
				    if (FormElement[i].checked == true){
						  radio_checked = true;
						  break;						  
				    }
			 }
	   }
	   return radio_checked;
	   
}
function form_has_radios(FormElement, FieldName){
	   var has_radios = false;
	   for (var i = 0; i < FormElement.length; i++){
			 if ((FormElement[i].type == 'radio')||
				(FormElement[i].type == 'checkbox')){
				    if (FieldName == FormElement[i].name){
						  has_radios = true;
						  break;
				    }
			 }
	   }
	   return has_radios;
}
function r_chk_selects(FormElement, fieldName) {
	   var isValid = false;
	   if (is_select(FormElement, fieldName)){	   
			 for (var i = 0; i < FormElement.length; i++){
				    if (FormElement[i].type == 'select-one' &&
					   FormElement[i].name == fieldName){
						  var SelectElement = FormElement[i];
						  for (var j = 0; j < SelectElement.length; j++){
								if (SelectElement[j].value != '' &&
								    SelectElement[j].selected == true){
									   isValid = true;
									   break;
								}
						  }
						  break;
				    }
			 }
			 return isValid;
	   } else {
			 return true;
	   }
}

// X_Chk: XLS check
function x_chk(form,no_inputs,fieldname,i) {
        for (var j = 0; j < no_inputs; j++)     {
                if (form.elements[j].name == fieldname)
                        break;
        }

        var msg_addition = "";
        var xml = form.elements[j].value;
        var res = xml.toLowerCase(); 
        if (res.indexOf ('.xls', 0) < 0) {
                msg_addition = form.elements[i].value;
        }

        return(msg_addition);
}

function is_select(FormElement, fieldName){
	   var element_is_select = false;
	   for (var i = 0; i < FormElement.length; i++){
			 if (FormElement[i].type == 'select-one' &&
				FormElement[i].name == fieldName){
				    element_is_select = true;
				    break;
			 }
	   }
	   return element_is_select;
}
	   
//-->
/* -----------------------------------
 * $Log: valida.js,v $
 * Revision 1.23  2007/11/13 00:00:37  javier
 * se agrega nuevo validador
 *
 * Revision 1.22  2007/01/25 17:55:53  javier
 *  nueva validacion
 *
 * Revision 1.21  2007/01/19 08:35:39  javier
 * bugfixes
 *
 * Revision 1.20  2007/01/18 11:33:29  javier
 * bugfix
 *
 * Revision 1.19  2007/01/12 09:58:47  javier
 * timeout menos agresivo
 *
 * Revision 1.18  2006/10/31 01:38:23  javier
 * bugfix a manejo de inegers
 *
 * Revision 1.17  2006/09/28 19:31:22  pop
 * bugfix a rutina a_chk
 *
 * Revision 1.16  2006/09/13 05:42:37  javier
 * validacion en tiempo real
 *
 * Revision 1.15  2006/09/12 04:21:52  javier
 * validacion de RFC
 *
 * Revision 1.14  2006/09/12 00:55:05  javier
 * pre-validacion por cada elemento
 *
 * Revision 1.13  2006/06/27 15:07:49  javier
 * typo fix
 *
 * Revision 1.12  2006/03/28 04:18:29  javier
 * bugfix
 *
 * Revision 1.11  2005/11/07 16:56:16  pop
 * se agrega nuevo detector de tipo de browser y se agrega generacion de
 * ventana para Help
 *
 * Revision 1.10  2005/09/26 17:20:08  javier
 * bugfix
 *
 * Revision 1.9  2005/08/27 11:12:24  javier
 * soporte para checkboxes
 *
 * Revision 1.8  2005/07/02 17:30:06  javier
 * bugfixes
 *
 * Revision 1.7  2005/06/30 20:22:01  javier
 * <select> validation
 *
 * Revision 1.6  2005/06/21 23:13:33  javier
 * nuevo funcion de confirmacion de forma
 *
 * Revision 1.5  2005/06/17 16:17:08  javier
 * bugfix
 *
 * Revision 1.4  2005/06/17 14:36:27  javier
 * added more checks on campaign days
 *
 * Revision 1.3  2005/04/01 22:47:56  javier
 * radio button validation
 *
 * Revision 1.2  2005/01/30 18:00:05  javier
 * typo fix
 *
 * Revision 1.1  2005/01/30 17:16:52  javier
 * First CheckIn
 *
 * -----------------------------------
 */
