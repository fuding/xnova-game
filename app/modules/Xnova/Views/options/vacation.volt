<router-form action="{{ url('options/change/') }}">
	<table class="table">
		<tr>
			<td class="c" colspan="2">Режим отпуска</td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th colspan="2">Режим отпуска включён до: <br/>{{ parse['um_end_date'] }}</th>
		</tr>
		<tr>
			<th>{{ _text('xnova', 'username') }}</th>
			<th><input name="username" size="20" value="{{ parse['opt_usern_data'] }}" type="hidden">{{ parse['opt_usern_data'] }}</th>
		</tr>
		<tr>
			<th><a title="{{ _text('xnova', 'vacations_tip') }}">{{ _text('xnova', 'mode_vacations') }}</a></th>
			<th><input name="vacation"{{ parse['opt_modev_data'] }} type="checkbox" title=""></th>
		</tr>
		<tr>
			<th><a title="{{ _text('xnova', 'deleteaccount_tip') }}">{{ _text('xnova', 'deleteaccount') }}</a></th>
			<th><input name="delete"{{ parse['opt_delac_data'] }} type="checkbox" title=""></th>
		</tr>
		<tr>
			<th colspan="2"><input type="submit" value="Сохранить изменения"/></th>
		</tr>
	</table>
</router-form>