function setPhoto(div_id, input_id, data) {
	var div = document.getElementById(div_id),
			input = document.getElementById(input_id);
			
	div.style.backgroundImage = 'url(data:image/png;base64,' + data + ')'
	input.setAttribute('value', data);
}