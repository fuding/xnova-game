<div class="card">
	<table class="table table-striped">
		{{ parse['desc'] }}{{ parse['edit'] }}{{ parse['name'] }}{{ parse['member'] }}{{ parse['member_row'] }}{{ parse['mail'] }}{{ parse['leader'] }}
		<thead>
			<tr>
				<th><a href="{{ url('alliances/?cmd=sort&type=id') }}">ID</a></th>
				<th>Название</th>
				<th>Обозначение</th>
				<th>Лидер</th>
				<th>Основан</th>
				<th>Описание альянса</th>
				<th>Кол-во учатников</th>
				<th></th>
				<th></th>
			</tr>
		</thead>
		{% for u in parse['alliance'] %}
			<tr>
				<td>{{ u['id'] }}</td>
				<td><a href="{{ url('alliances/allyname/'~u['id']~'/') }}">{{ u['name'] }}</a></td>
				<td><a href="{{ url('alliances/allyname/'~u['id']~'/') }}">{{ u['tag'] }}</a></td>
				<td><a href="{{ url('alliances/leader/'~u['id']~'/') }}">{{ u['username'] }}</a></td>
				<td>{{ date("d/m/Y H:i:s", u['create_time']) }}</td>
				<td><a href="{{ url('alliances/desc/'~u['id']~'/') }}">Смотреть</a> / <a href="{{ url('alliances/edit/'~u['id']~'/') }}">Редактировать</a></td>
				<td><a href="{{ url('alliances/mitglieder/'~u['id']~'/') }}">{{ u['members'] }}</a></td>
				<td><a href="{{ url('alliances/mail/'~u['id']~'/') }}"><img src="{{ static_url('assets/images/alliance/r5.png') }}"></a></td>
				<td><a href="{{ url('alliances/del/'~u['id']~'/') }}">X</a></td>
			</tr>
		{% endfor %}
		<tr><th colspan="9">Всего {{ parse['alliance']|length }} альянсов</th></tr>
	</table>
</div>