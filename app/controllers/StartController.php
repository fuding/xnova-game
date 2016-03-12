<?php
namespace App\Controllers;

/**
 * @author AlexPro
 * @copyright 2008 - 2016 XNova Game Group
 * Telegram: @alexprowars, Skype: alexprowars, Email: alexprowars@gmail.com
 */

use App\Helpers;
use App\Lang;

class StartController extends ApplicationController
{
	public function initialize()
	{
		parent::initialize();

		Lang::includeLang('reg');
	}

	public function indexAction ()
	{
		$error = '';

		if ($this->user->sex == 0 || $this->user->avatar == 0)
		{
			if ($this->request->hasPost('save'))
			{
				$arUpdate = [];

				if (!preg_match("/^[А-Яа-яЁёa-zA-Z0-9_\-\!\~\.@ ]+$/u", $this->request->getPost('character')))
				{
					$error .= _getText('error_charalpha');
				}

				$ExistUser = $this->db->query("SELECT `id` FROM game_users WHERE `username` = '" . trim($this->request->getPost('character')) . "' AND id != ".$this->user->getId()." LIMIT 1")->fetch();

				if (isset($ExistUser['id']))
				{
					$error .= _getText('error_userexist');
				}

				$face = Helpers::CheckString($this->request->getPost('face', 'string', ''));

				if ($face != '')
				{
					$face = explode('_', $face);

					$face[0] = intval($face[0]);

					if ($face[0] != 1 && $face[0] != 2)
					{
						$arUpdate['sex'] = 0;
						$arUpdate['avatar'] = 1;
					}
					else
					{
						$face[1] = intval($face[1]);

						if ($face[1] < 1 || $face[1] > 8)
							$face[1] = 1;

						$arUpdate['sex'] = $face[0];
						$arUpdate['avatar'] = $face[1];
					}
				}

				if (!$error)
				{
					$arUpdate['username'] = strip_tags(trim($this->request->getPost('character')));

					$this->user->saveData($arUpdate);

					$this->response->redirect('overview/');
					$this->view->disable();
				}
			}

			$this->view->pick('shared/start/sex');
			$this->view->setVar('name', $this->user->username);
		}
		elseif ($this->user->race == 0)
		{
			Lang::includeLang('infos');

			$this->view->pick('shared/start/race');

			if ($this->request->hasPost('save'))
			{
				$r = $this->request->getPost('race', 'int', 0);
				$r = ($r < 1 || $r > 4) ? 0 : $r;

				if ($r != 0)
				{
					$update = ['race' => $r, 'bonus' => (time() + 86400)];

					foreach ($this->game->reslist['officier'] AS $oId)
						$update[$this->game->resource[$oId]] = time() + 86400;

					$this->user->saveData($update);

					$this->game->setRequestData(['redirect' => '/tutorial/']);
					$this->view->disable();
				}
				else
					$error = 'Выберите фракцию';
			}
		}

		$this->view->setVar('message', $error);
		$this->tag->setTitle('Выбор персонажа');
		$this->showTopPanel(false);
	}
}