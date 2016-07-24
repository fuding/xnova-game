<?= $this->tag->getDoctype() ?>
<!--[if IE 8]> <html lang="ru" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="ru" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!--> <html lang="ru" class="no-js"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
   <meta charset="utf-8" />
	<?php echo $this->tag->getTitle(); ?>
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta content="width=device-width, initial-scale=1.0" name="viewport" />
   <meta content="" name="description" />
   <meta content="" name="author" />
   <meta name="MobileOptimized" content="320">
	<link href='//fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&subset=latin,cyrillic' rel='stylesheet' type='text/css'>
   <!-- BEGIN GLOBAL MANDATORY STYLES -->
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" href="<?=$this->url->getBaseUri() ?>assets/admin/plugins/data-tables/DT_bootstrap.css"/>
   <!-- END GLOBAL MANDATORY STYLES -->
   <!-- BEGIN THEME STYLES -->
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/style-metronic.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/style.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/style-responsive.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/plugins.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/themes/default.css" rel="stylesheet" type="text/css"/>
   <link href="<?=$this->url->getBaseUri() ?>assets/admin/css/custom.css" rel="stylesheet" type="text/css"/>
   <!-- END THEME STYLES -->
	<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery-1.10.2.min.js" type="text/javascript"></script>
   <link rel="shortcut icon" href="/favicon.ico" />
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body class="page-boxed">
<!-- BEGIN HEADER -->
<div class="header navbar navbar-inverse navbar-static-top">
	<!-- BEGIN TOP NAVIGATION BAR -->
	<div class="header-inner container">
		<!-- BEGIN LOGO -->
		<a class="navbar-brand" href="/">
			<img src="<?=$this->url->getBaseUri() ?>assets/admin/img/logo.png" alt="logo" class="img-responsive"/>
		</a>
		<!-- END LOGO -->
		<!-- BEGIN RESPONSIVE MENU TOGGLER -->
		<a href="javascript:;" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
			<img src="<?=$this->url->getBaseUri() ?>assets/admin/img/menu-toggler.png" alt=""/>
		</a>
		<!-- END RESPONSIVE MENU TOGGLER -->
		<!-- BEGIN TOP NAVIGATION MENU -->
		<ul class="nav navbar-nav pull-right">
			<!-- BEGIN USER LOGIN DROPDOWN -->
			<li class="dropdown user">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
					<img alt="" src="<?=$this->url->getBaseUri() ?>assets/admin/img/avatar1_small.jpg"/>
					<span class="username"><?= $this->user->username ?></span>
					<i class="fa fa-angle-down"></i>
				</a>
				<ul class="dropdown-menu">
					<li><a href="/admin/mode/playersadmin/result/usr_data/username/<?=$userId ?>/"><i class="fa fa-user"></i> Профиль</a></li>
					<li class="divider"></li>
					<li><a href="javascript:;" id="trigger_fullscreen"><i class="fa fa-move"></i> На весь экран</a></li>
					<li><a href="<?=$this->url->get('logout/') ?>"><i class="fa fa-key"></i> Выход</a></li>
				</ul>
			</li>
			<!-- END USER LOGIN DROPDOWN -->
		</ul>
		<!-- END TOP NAVIGATION MENU -->
	</div>
	<!-- END TOP NAVIGATION BAR -->
</div>
<!-- END HEADER -->
<div class="clearfix"></div>
<!-- BEGIN CONTAINER -->
<div class="container">
	<div class="page-container">
		<!-- BEGIN SIDEBAR -->
		<div class="page-sidebar-wrapper">
			<div class="page-sidebar navbar-collapse collapse">
				<!-- BEGIN SIDEBAR MENU -->
				<ul class="page-sidebar-menu">
					<li class="sidebar-toggler-wrapper">
						<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
						<div class="sidebar-toggler hidden-phone"></div>
						<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
					</li>
					<li class="sidebar-search-wrapper">
						<!-- BEGIN RESPONSIVE QUICK SEARCH FORM -->
						<form class="sidebar-search" action="<?=$this->url->get('admin/playersadmin/result/usr_data/') ?>" method="POST">
							<div class="form-container">
								<div class="input-box">
									<a href="javascript:;" class="remove"></a>
									<input type="text" name="username" placeholder="Поиск..."/>
									<input type="button" class="submit" value=" "/>
								</div>
							</div>
						</form>
						<!-- END RESPONSIVE QUICK SEARCH FORM -->
					</li>
					<? foreach ($menu AS $item): ?>
						<li class="start <?=(($mode == $item['alias']) ? 'active' : '') ?> ">
							<a href="/admin/<?= $item['alias'] ?>/">
								<i class="fa fa-<?=is($item, 'icon') ?>"></i>
								<span class="title"><?=$item['name'] ?></span>
								<? if ($mode == $item['alias']): ?>
									<span class="selected"></span>
								<? endif; ?>
							</a>
							<? if (isset($item['children']) && count($item['children'])): ?>
								<ul class="sub-menu">
									<? foreach ($item['children'] AS $sub): ?>
										<li>
											<a href="/admin/<?= $item['alias'] ?>/<?= $sub['alias'] ?>/">
											<? if ($sub['icon'] != ''): ?>
												<i class="fa fa-<?= $sub['icon'] ?>"></i>
											<? endif; ?>
											<?= $sub['name'] ?></a>
										</li>
									<? endforeach; ?>
								</ul>
							<? endif; ?>
						</li>
					<? endforeach; ?>
				</ul>
				<!-- END SIDEBAR MENU -->
			</div>
		</div>
		<!-- END SIDEBAR -->
		<!-- BEGIN PAGE -->
		<div class="page-content-wrapper">
			<div class="page-content">
				<!-- BEGIN PAGE HEADER-->
				<div class="row">
					<div class="col-md-12">
						<!-- BEGIN PAGE TITLE & BREADCRUMB-->
						<h3 class="page-title">
							<?= $this->tag->getTitle(false) ?>
						</h3>
						<ul class="page-breadcrumb breadcrumb">
							<li>
								<i class="fa fa-home"></i>
								<a href="/">Главная</a>
								<i class="fa fa-angle-right"></i>
							</li>
							<li><a href="/admin/<?= mb_strtolower($mode, 'utf-8') ?>/"><?= $this->tag->getTitle(false) ?></a></li>
						</ul>
						<!-- END PAGE TITLE & BREADCRUMB-->
					</div>
				</div>
				<!-- END PAGE HEADER-->
				<div class="clearfix"></div>
				<? if (isset($error) && $error != ''): ?>
					<div class="note note-danger">
						<p><?=$error ?></p>
					</div>
				<? endif; ?>

				<?php echo $this->getContent() ?>

			</div>
			<!-- END PAGE -->
		</div>
			</div>
		<!-- END CONTAINER -->
		<!-- BEGIN FOOTER -->
			<div class="container">
		<div class="footer">
		   <div class="footer-inner">
			  <?=date("Y") ?> &copy; XGG
		   </div>
		   <div class="footer-tools">
			  <span class="go-top">
			  <i class="icon-angle-up"></i>
			  </span>
		   </div>
		</div>
				</div>
				</div>
		<!-- END FOOTER -->
		<!-- BEGIN CORE PLUGINS -->
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery-ui/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/bootstrap-hover-dropdown/twitter-bootstrap-hover-dropdown.min.js" type="text/javascript" ></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery.blockui.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/jquery.cookie.min.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/plugins/uniform/jquery.uniform.min.js" type="text/javascript" ></script>
		<!-- END CORE PLUGINS -->
		<!-- BEGIN PAGE LEVEL SCRIPTS -->
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/scripts/app.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/scripts/index.js" type="text/javascript"></script>
		<script src="<?=$this->url->getBaseUri() ?>assets/admin/scripts/tasks.js" type="text/javascript"></script>
		<!-- END PAGE LEVEL SCRIPTS -->
		<script>
		   jQuery(document).ready(function() {
			  App.init(); // initlayout and core plugins
			  Index.init();
		   });
		</script>
		<!-- END JAVASCRIPTS -->
	</body>
	<!-- END BODY -->
</html>