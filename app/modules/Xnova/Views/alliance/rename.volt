<router-form action="{{ url('alliance/admin/edit/name/') }}">
	<div class="block">
		<div class="title">Введите новое название альянса</div>
		<div class="content table border-0 middle">
			<div class="row">
				<div class="col th">
					<input type="text" name="name" value="{{ name }}">
					<input type="submit" value="Изменить">
				</div>
			</div>
			<div class="row c">
				<router-link to="{{ url('alliance/admin/edit/ally/') }}">вернутся к обзору</router-link>
			</div>
		</div>
	</div>
</router-form>