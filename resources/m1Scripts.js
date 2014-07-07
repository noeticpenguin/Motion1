/**
 * We have jQuery, but lets not use it just to be sure that that this works.
 */
document.addEventListener('DOMContentLoaded', function() {
	try {


		document.getElementById("username").onchange = function() {
			// console.log(m1u);
			// console.log(document.getElementById("username").value);
			if (m1u) {
				m1u.setUsername_(document.getElementById("username").value);
			}
		};
	} catch (exception) {
		console.log('Unable to find id: Username, likely because we\'ve already logged in', exception);
	}
});

function safeToReload() {
	var inputValues = $.makeArray($("[class*='uiInput']").find('input').map(function(x,y){ if(y.value !== ""){return y.value;}}));
	var textAreasValues = $.makeArray($("[class*='uiInput']").find('textarea').map(function(x,y){ if(y.value !== ""){return y.value;}}));

	var textRep;
	if(inputValues && inputValues.length !== 0) {
		textRep = inputValues.join("").trim();
	}

	if(textAreasValues && textAreasValues.length !== 0) {
		textRep += textAreasValues.join("").trim();
	}

	console.log(textRep);
	return (textRep === "" || textRep === undefined) ? true : false;
}