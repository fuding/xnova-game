<router-form action="{{ url('options/change/') }}">
	<tabs>
		<tab name="Информация">
			<table class="table">
				<tr>
					<th width="50%">
						Ник
						<br>
						<span class="negative">Можно менять не чаще раза в сутки</span>
					</th>
					<th>
						{% if parse['opt_usern_datatime'] < (time() - 86400) %}
							<input name="username" size="20" value="{{ parse['opt_usern_data'] }}" type="text" title="">
						{% else %}
							{{ parse['opt_usern_data'] }}
						{% endif %}
					</th>
				</tr>
				{% if config.view.get('socialIframeView', 0) == 0 %}
					{% if is_email(parse['opt_mail_data']) %}
						<tr>
							<th>Старый пароль</th>
							<th><input name="password" size="20" value="" type="password" title=""></th>
						</tr>
						<tr>
							<th>Новый пароль (мин. 8 Знаков)</th>
							<th><input name="new_password" size="20" maxlength="40" type="password" title=""></th>
						</tr>
						<tr>
							<th>Новый пароль (повтор)</th>
							<th><input name="new_password_confirm" size="20" maxlength="40" type="password" title=""></th>
						</tr>
					{% endif %}
					<tr>
						<th>Адрес e-mail (логин)</th>
						<th>
							{% if is_email(parse['opt_mail_data']) is false %}
								<input type="text" name="email" value="" title="">
							{% else %}
								{{ parse['opt_mail_data'] }} <router-link to="{{ url('options/email/') }}" class="button">сменить</router-link>
							{% endif %}
						</th>
					</tr>
				{% endif %}
				<tr>
					<th>Пол</th>
					<th><select name="sex" title="">
						<option value="M">мужской</option>
						<option value="F" {{ parse['sex'] == 2 ? ' selected' : '' }}>женский</option>
					</select></th>
				</tr>
				<tr>
					<th colspan="2"><input value="Сохранить изменения" type="submit"></th>
				</tr>
			</table>
		</tab>
		<tab name="Интерфейс">
			{% if config.view.get('socialIframeView', 0) != 0 %}
				<div style="display: none">
					<input name="chatbox"{{ parse['opt_chatbox_data'] }} type="checkbox" title="">
					<input name="planetlistselect"{{ parse['opt_planetlistselect_data'] }} type="checkbox" title="">
				</div>
			{% endif %}
			<table class="table">
				<tr>
					<th rowspan="2" width="50%">Упорядочить планеты по:</th>
					<th>
						<select name="settings_sort" style='width:170px' title="">
							<option value="0" {% if parse['settings']['planet_sort'] is defined and parse['settings']['planet_sort'] == 0 %}selected{% endif %}>{{ _text('xnova', 'opt_lst_ord0') }}</option>
							<option value="1" {% if parse['settings']['planet_sort'] is defined and parse['settings']['planet_sort'] == 1 %}selected{% endif %}>{{ _text('xnova', 'opt_lst_ord1') }}</option>
							<option value="2" {% if parse['settings']['planet_sort'] is defined and parse['settings']['planet_sort'] == 2 %}selected{% endif %}>{{ _text('xnova', 'opt_lst_ord2') }}</option>
							<option value="3" {% if parse['settings']['planet_sort'] is defined and parse['settings']['planet_sort'] == 3 %}selected{% endif %}>Типу</option>
						</select>
					</th>
				</tr>
				<tr>
					<th>
						<select name="settings_order" style='width:170px' title="">
							<option value="0" {% if parse['settings']['planet_sort_order'] is defined and parse['settings']['planet_sort_order'] == 0 %}selected{% endif %}>{{ _text('xnova', 'opt_lst_cla0') }}</option>
							<option value="1" {% if parse['settings']['planet_sort_order'] is defined and parse['settings']['planet_sort_order'] == 1 %}selected{% endif %}>{{ _text('xnova', 'opt_lst_cla1') }}</option>
						</select>
					</th>
				</tr>
				<tr>
					<th>Кол-во отправляемых шпионских зондов в меню "Космос"</th>
					<th><input name="spy" value="{{ parse['spy'] }}" type="text" title=""></th>
				</tr>
				<tr>
					<th>Участвовать в рекордах</th>
					<th><input name="records"{{ parse['opt_record_data'] }} type="checkbox" title=""></th>
				</tr>
				<tr>
					<th>Использовать BB коды в сообщениях</th>
					<th><input name="bbcode"{{ parse['opt_bbcode_data'] }} type="checkbox" title=""></th>
				</tr>
				<tr>
					<th>Показывать только доступные постройки</th>
					<th><input name="available"{{ parse['opt_available_data'] }} type="checkbox" title=""></th>
				</tr>
				{% if config.view.get('socialIframeView', 0) == 0 %}
					<tr>
						<th>Показывать панель чата</th>
						<th><input name="chatbox"{{ parse['opt_chatbox_data'] }} type="checkbox" title=""></th>
					</tr>
				{% endif %}
				<tr>
					<th>Цвет ваших сообщений в чате</th>
					<th>
						<select name='color' style='width:170px' title="">
							{% for id, color in _text('xnova', 'colors') if color[1] != '' %}
								<option value="{{ id }}" {{ parse['color'] == id ? 'selected' : '' }} style="color:{{ color[0] }}">{{ color[1] }}</option>
							{% endfor %}
						</select>
					</th>
				</tr>
				<tr>
					<th>Часовой пояс</th>
					<th><select name='timezone' style='width:170px' title="">
						<option value="-30" {{ parse['timezone'] == (-30) ? 'selected' : '' }}>-12</option>
						<option value="-28" {{ parse['timezone'] == (-28) ? 'selected' : '' }}>-11</option>
						<option value="-26" {{ parse['timezone'] == (-26) ? 'selected' : '' }}>-10</option>
						<option value="-24" {{ parse['timezone'] == (-24) ? 'selected' : '' }}>-9</option>
						<option value="-22" {{ parse['timezone'] == (-22) ? 'selected' : '' }}>-8</option>
						<option value="-20" {{ parse['timezone'] == (-20) ? 'selected' : '' }}>-7</option>
						<option value="-18" {{ parse['timezone'] == (-18) ? 'selected' : '' }}>-6</option>
						<option value="-16" {{ parse['timezone'] == (-16) ? 'selected' : '' }}>-5</option>
						<option value="-14" {{ parse['timezone'] == (-14) ? 'selected' : '' }}>-4</option>
						<option value="-12" {{ parse['timezone'] == (-12) ? 'selected' : '' }}>-3</option>
						<option value="-10" {{ parse['timezone'] == (-10) ? 'selected' : ''}}>-2</option>
						<option value="-8" {{ parse['timezone'] == (-8) ? 'selected' : ''}}>-1</option>
						<option value="-6" {{ parse['timezone'] == (-6) ? 'selected' : ''}}>0</option>
						<option value="-4" {{ parse['timezone'] == (-4) ? 'selected' : ''}}>+1</option>
						<option value="-2" {{ parse['timezone'] == (-2) ? 'selected' : ''}}>+2</option>
						<option value="0" {{ parse['timezone'] == 0 ? 'selected' : ''}}>+3 (Московское время)</option>
						<option value="2" {{ parse['timezone'] == 2 ? 'selected' : ''}}>+4</option>
						<option value="4" {{ parse['timezone'] == 4 ? 'selected' : ''}}>+5</option>
						<option value="6" {{ parse['timezone'] == 6 ? 'selected' : ''}}>+6</option>
						<option value="8" {{ parse['timezone'] == 8 ? 'selected' : ''}}>+7</option>
						<option value="10" {{ parse['timezone'] == 10 ? 'selected' : ''}}>+8</option>
						<option value="12" {{ parse['timezone'] == 12 ? 'selected' : ''}}>+9</option>
						<option value="14" {{ parse['timezone'] == 14 ? 'selected' : ''}}>+10</option>
						<option value="16" {{ parse['timezone'] == 16 ? 'selected' : ''}}>+11</option>
						<option value="18" {{ parse['timezone'] == 18 ? 'selected' : ''}}>+12</option>
					</select></th>
				</tr>
				<tr>
					<th>Аватар</th>
					<th>
						{% if parse['avatar'] != '' %}
							<img src="{{ parse['avatar'] }}" height="100"><br>
							<label>
								<input type="checkbox" name="image_delete" value="Y">
								Удалить
							</label>
							<br><br>
						{% endif %}

						<input type="file" name="image" value=""><br>
						<small>Картинки уменьшаются до размера в 300x300 пикселей</small>
					</th>
				</tr>
				<tr>
					<th colspan="2"><input value="Сохранить изменения" type="submit"></th>
				</tr>
			</table>
		</tab>
		<tab name="Описание">
			<table class="table">
				<tr>
					<th colspan="2" class="p-a-0">
						<text-editor text="{{ replace('!<br.*>!iU', "\n", parse['about']) }}"></text-editor>
					</th>
				</tr>
				<tr>
					<th colspan="2"><input value="Сохранить изменения" type="submit"></th>
				</tr>
			</table>
		</tab>
		<tab name="Отпуск / Удаление">
			<table class="table">
				<tr>
					<th width="50%"><a title="Режим отпуска нужен для защиты планет во время вашего отсутствия">Включить режим отпуска</a></th>
					<th><input name="vacation"{{ parse['opt_modev_data'] }} type="checkbox" title=""></th>
				</tr>
				<tr>
					<th colspan="2">
						<span class="negative">Режим отпуска включается минимум на 2 суток!<br>Пока это время не прошло, выключить режим отпуска НЕВОЗМОЖНО!</span>
					</th>
				</tr>
				<tr>
					<th><a title="Профиль будет удалён через 7 дней">Удалить профиль</a></th>
					<th><input name="delete"{{ parse['opt_delac_data'] }} type="checkbox" title=""></th>
				</tr>
				<tr>
					<th colspan="2">
						<span class="negative">Ваш профиль будет удален спустя несколько дней, в течение которых вы можете отменить данную процедуру.</span>
					</th>
				</tr>
				<tr>
					<th colspan="2"><input value="Сохранить изменения" type="submit"></th>
				</tr>
			</table>
		</tab>
		<tab name="Личное дело">
			<table class="table">
				<tr>
					<td class="c">Добавить запись в личное дело</td>
				</tr>
				<tr>
					<th><textarea name="ld" cols="" rows="5" title=""></textarea></th>
				</tr>
				<tr>
					<th><input value="Записать" type="submit"></th>
				</tr>
			</table>
		</tab>
		{% if config.view.get('socialIframeView', 0) == 0 %}
			<tab name="Точки входа">
				{% if parse['auth']|length %}
					<table class="table">
						<tr>
							<td class="c">Аккаунт</td>
							<td class="c">Дата регистрации</td>
							<td class="c">Последняя авторизация</td>
						</tr>
						{% for auth in parse['auth'] %}
							<tr>
								<th>{{ auth['external_id'] }}</th>
								<th>{{ game.datezone("d.m.Y H:i:s", auth['create_time']) }}</th>
								<th>{{ auth['enter_time'] > 0 ? game.datezone("d.m.Y H:i:s", auth['enter_time']) : '-' }}</th>
							</tr>
						{% endfor %}
					</table>
				{% endif %}
				<table class="table">
					<tr>
						<td class="c">Привязать аккаунт к социальным сетям</td>
					</tr>
					<tr>
						<th>
							<br>
							<script type="text/javascript" src="//ulogin.ru/js/ulogin.js"></script>
							<div id="uLogin" x-ulogin-params="display=panel;fields=first_name,last_name,photo;providers=vkontakte,odnoklassniki,facebook,twitter,yandex,googleplus,mailru;redirect_uri={{ ("//"~request.getServer('SERVER_NAME')~"/options/external/")|url_encode }}"></div>
							<br>
						</th>
					</tr>
				</table>
			</tab>
		{% endif %}
	</tabs>
</router-form>

{% if parse['bot_auth'] is type('array') %}
	<br><br>
	<div class="table">
		<div class="row">
			<div class="col-12 th">
				Ваш код для привязки Telegram-бота:<br><br><b>{{ parse['bot_auth']['code'] }}</b>
			</div>
		</div>
	</div>
{% endif %}