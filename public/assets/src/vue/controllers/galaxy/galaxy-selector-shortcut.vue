<template>
	<table style="max-width:200px;width:100%;margin: 0 auto">
		<tr>
			<td class="c">
				<select v-on:change="changePlanet" style="width:100%">
					<option >--- выберите планету ---</option>

					<option v-for="item in items"
							:value="'galaxy='+item.g+'&system='+item.s+''"
							:selected="item.c ? 'selected' : ''">
						{{ item.n }} [{{ item.g }}:{{ item.s }}:{{ item.p }}]
					</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>
				<input value="Просмотр" type="submit" style="width:100%">
			</th>
		</tr>
	</table>
</template>

<script>
	export default {
		name: "galaxy-selector-shortcut",
		props: ["items"],
		methods: {
			changePlanet ($event) {
				this.$router.push('/galaxy/r/3/?'+$event.target.value);
			}
		}
	}
</script>