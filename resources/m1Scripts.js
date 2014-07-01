/**
 * We have jQuery, but lets not use it just to be sure that that this works.
 */
document.getElementById("username").onchange = function() {
    console.log(m1u);
    console.log(document.getElementById("username").value);
    if (m1u) {
        m1u.setUsername_(document.getElementById("username").value);
    }
};

/**
 * Now we'll load jQuery and our dirty-checking plugin.
 */
function waitUntilJQueryIsLoaded() {
	if (window.$) {
		runAfterJqueryIsLoaded();
	} else {
		setTimeout(waitUntilJQueryIsLoaded, 50);
	}
}

function runAfterJqueryIsLoaded() {
	$('form').areYouSure({
		'silent':true,
		change: function() {
			// Enable save button only if the form is dirty. i.e. something to save.
			if ($(this).hasClass('dirty')) {
				if(m1u){
					m1u.safeToRefresh_(false);
				}
			} else {
				if(m1u){
					m1u.safeToRefresh_(true);
				}
			}
		}
	});

}

waitUntilJQueryIsLoaded();