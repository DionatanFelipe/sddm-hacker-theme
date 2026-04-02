var matrix = {
	drops: [],
	chars: "0123456789ABCDEF",
	fontSize: 14,

	init: function (width, height) {
		this.drops = [];
		var columns = Math.floor(width / this.fontSize);
		for (var x = 0; x < columns; x++) {
			this.drops[x] = Math.random() * height / this.fontSize;
		}
	},

	drawMatrix: function (ctx, width, height) {
		if (!this.drops.length) {
			this.init(width, height);
		}

		// Semi-transparent black background for trail effect
		ctx.fillStyle = "rgba(0, 0, 0, 0.07)";
		ctx.fillRect(0, 0, width, height);

		// Green text for matrix effect
		ctx.fillStyle = "#00ff9c";
		ctx.font = this.fontSize + "px 'JetBrainsMono Nerd Font Propo'";

		for (var i = 0; i < this.drops.length; i++) {
			var text = this.chars.charAt(Math.floor(Math.random() * this.chars.length));
			ctx.fillText(text, i * this.fontSize, this.drops[i] * this.fontSize);

			// Reset drop to top if it reaches bottom
			if (this.drops[i] * this.fontSize > height && Math.random() > 0.975) {
				this.drops[i] = 0;
			}
			this.drops[i]++;
		}
	}
};
