<?php

namespace Admin\Controllers;

use Admin\Controller;

/**
 * @RoutePrefix("/admin/error")
 * @Route("/")
 * @Route("/{action}/")
 * @Route("/{action}{params:(/.*)*}")
 */
class ErrorController extends Controller
{
	public function initialize ()
	{
		parent::initialize();
	}

	public function indexAction ()
	{

	}

	public function notFoundAction ()
	{
		$this->message('Запрашиваемая вами страница не найдена', _getText('sys_noaccess'));
	}
}