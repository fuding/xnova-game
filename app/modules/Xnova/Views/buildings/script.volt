<form name="Atr" action="">
	<div class="separator"></div>
	<table width="100%">
		<tr>
			<th>
				Текущее производство: <div id="bx" class="z"></div>
			</th>
		</tr>
		<tr>
			<th><select name="auftr" disabled size="5" style="width:100%;" title=""></select></th>
		</tr>
		<tr>
			<td class="c">Оставшееся время <?=$build['time'] ?></td>
		</tr>
	</table>
	<div class="separator"></div>
</form>
<script type="text/javascript">
	var v = new Date();
	var p = 0;
	var g = <?=$build['b_hangar_id_plus'] ?>;
	var s = 0;
	var of = 1;
	var c = new Array(<?=$build['c'] ?>'');
	var b = new Array(<?=$build['b'] ?>'');
	var a = new Array(<?=$build['a'] ?>'');
	var aa = 'завершено';

	xd();

	function t()
	{
		var n = new Date();
		var s = c[p] - g - Math.round((n.getTime() - v.getTime()) / 1000);
		s = Math.round(s);
		var m = 0;
		var h = 0;

		if (s < 0)
		{
			a[p]--;
			xd();
			if (a[p] <= 0)
			{
				p++;
				xd();
			}
			g = 0;
			v = new Date();
			s = 0;
		}
		if (s > 59)
		{
			m = Math.floor(s / 60);
			s = s - m * 60;
		}
		if (m > 59)
		{
			h = Math.floor(m / 60);
			m = m - h * 60;
		}
		if (s < 10)
			s = "0" + s;

		if (m < 10)
			m = "0" + m;

		if (p > b.length - 2)
			$("#bx").html(aa);
		else
			$("#bx").html(b[p] + " " + h + ":" + m + ":" + s);

		setTimeout(t, 1000);
	}

	function xd()
	{
		while (document.Atr.auftr.length > 0)
			document.Atr.auftr.options[document.Atr.auftr.length - 1] = null;

		if (p > b.length - 2)
			document.Atr.auftr.options[document.Atr.auftr.length] = new Option(aa);

		for (var iv = p; iv <= b.length - 2; iv++)
		{
			var act;

			if (iv == p)
				act = " (в процессе)";
			else
				act = "";

			document.Atr.auftr.options[document.Atr.auftr.length] = new Option(a[iv] + " \"" + b[iv] + "\"" + act, iv + of);
		}
	}

	t();
</script>