<table class="table">
	<tr>
		<td class="c" colspan="3">Привлечённые игроки</td>
	<tr>
	{% if parse['ref']|length > 0 %}
		<tr>
			<td class="c">Ник</td>
			<td class="c">Дата регистрации</td>
			<td class="c">Уровень развития</td>
		</tr>
		{% for list in parse['ref'] %}
			<tr>
				<th>
					{% if game.datezone("d", list['create_time']) >= 15 %}
						+
					{% endif %}
					<router-link to="{{ url('players/'~list['id']~'/') }}">{{ list['username'] }}</router-link>
				</th>
				<th>{{ game.datezone("d.m.Y H:i", list['create_time']) }}</th>
				<th>П:{{ list['lvl_minier'] }}, В:{{ list['lvl_raid'] }}</th>
			</tr>
		{% endfor %}
	{% else %}
		<tr>
			<th colspan="3">Нет привлеченных игроков</th>
		</tr>
	{% endif %}
</table>

{% if parse['you'] is defined %}
	<br><br>
	<table class="table">
		<tr>
			<th>Вы были привлечены игроком:</th>
			<th><router-link to="{{ url('players/'~parse['you']['id']~'/') }}">{{ parse['you']['username'] }}</router-link></th>
		</tr>
	</table>
{% endif %}

{% if config.view.get('socialIframeView', 0) == 0 %}
	<br><br>
	<table class="table">
		<tr>
			<th colspan="2" style="padding:15px;">
				Помоги проекту, поделись им с друзьями!<br><br>

				<script type="text/javascript" src="https://yandex.st/share/share.js" charset="utf-8"></script>
				<div class="yashare-auto-init"
					data-yashareL10n="ru"
					data-yashareTheme="counter"
					data-yashareType="small"
					data-yashareQuickServices="vkontakte,facebook,twitter,odnoklassniki,moimir,gplus"
					data-yashareLink="http{{ request.isSecure() ? 's' : '' }}://{{ request.getHttpHost() }}/?{{ userId }}"
					data-yashareTitle="{{ option('site_title') }}"
				></div>
			</th>
		</tr>
	</table>

	<div class="separator"></div>
	<table class="table">
		<tr>
			<td class="c">Юзербар</td>
		</tr>
		<tr>
			<th>
				<br>
				<img src="/userbar{{ userId }}.jpg">

				<br><br>
				HTML код:
				<br>
				<input style="width:100%" type="text" value="{{ htmlspecialchars('<a href="http'~(request.isSecure() ? 's' : '')~'://'~request.getHttpHost()~'/?'~userId~'"><img src="http'~(request.isSecure() ? 's' : '')~'://'~request.getHttpHost()~'/userbar'~userId~'.jpg"></a>') }}" title="">
				<div class="separator"></div>
				BB код:
				<input style="width:100%" type="text" value="{{ htmlspecialchars('[url=http'~(request.isSecure() ? 's' : '')~'://'~request.getHttpHost()~'.xnova.su/?'~userId~'][img]http'~(request.isSecure() ? 's' : '')~'://'~request.getHttpHost()~'.xnova.su/userbar'~userId~'.jpg[/img][/url]') }}" title="">
			</th>
		</tr>
	</table>
{% endif %}