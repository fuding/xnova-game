<div class="portlet box green">
	<div class="portlet-title">
		<div class="caption"><?=_getText('adm_mod_level') ?></div>
	</div>
	<div class="portlet-body form">
		<form action="<?=$this->url->get('admin/manager/level/') ?>" method="post" class="form-horizontal form-bordered">
			<input type="hidden" name="send" value="y">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><?=_getText('adm_player_nm') ?></label>
					<div class="col-md-9">
						<input type="text" class="form-control" name="player" title="">
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><?=_getText('adm_mess_lvl1') ?></label>
					<div class="col-md-9">
						<select class="form-control" name="authlvl" title="">
							<? foreach (_getText('user_level') AS $id => $level): ?>
								<option value="<?=$id ?>"><?=$level ?></option>
							<? endforeach; ?>
						</select>
					</div>
				</div>
				<div class="form-actions">
					<button type="submit" class="btn green"><?=_getText('adm_bt_change') ?></button>
				</div>
			</div>
		</form>
	</div>
</div>