<?php

namespace Xnova;

/**
 * @author AlexPro
 * @copyright 2008 - 2018 XNova Game Group
 * Telegram: @alexprowars, Skype: alexprowars, Email: alexprowars@gmail.com
 */

use DirectoryIterator;
use Friday\Core\Lang;
use Friday\Core\Options;
use Phalcon\Mvc\Controller as PhalconController;
use Phalcon\Mvc\View;
use Phalcon\Tag;

/**
 * Class ControllerBase
 * @property \Phalcon\Mvc\View view
 * @property \Phalcon\Tag tag
 * @property \Friday\Core\Assets\Manager assets
 * @property \Xnova\Database db
 * @property \Phalcon\Mvc\Model\Manager modelsManager
 * @property \Phalcon\Session\Adapter\Memcache session
 * @property \Phalcon\Http\Response\Cookies cookies
 * @property \Phalcon\Http\Request request
 * @property \Phalcon\Http\Response response
 * @property \Phalcon\Mvc\Router router
 * @property \Phalcon\Cache\Backend\Memcache cache
 * @property \Phalcon\Mvc\Url url
 * @property \Xnova\Models\User user
 * @property \Xnova\Models\Planet planet
 * @property \Friday\Core\Auth\Auth auth
 * @property \Phalcon\Mvc\Dispatcher dispatcher
 * @property \Phalcon\Flash\Direct flash
 * @property \Phalcon\Registry|\stdClass registry
 * @property \Phalcon\Config|\stdClass config
 * @property \Xnova\Game game
 */
class Controller extends PhalconController
{
	static private $isInitialized = false;

	private $views = [
		'header' => true,
		'footer' => true,
		'planets' => true,
		'menu' => true,
		'resources' => true,
		'chat' => true
	];

	public function initialize()
	{
		if (self::$isInitialized)
			return true;

		if ($this->getDI()->has('game'))
			new \Exception('game module not initialized');

		self::$isInitialized = true;

		if (function_exists('sys_getloadavg'))
		{
			$load = sys_getloadavg();

			if ($load[0] > 15)
			{
				header('HTTP/1.1 503 Too busy, try again later');
				die('Server too busy. Please try again later.');
			}
		}

		Lang::setLang($this->config->app->language, 'xnova');

		if ($this->request->isAjax())
			$this->view->disableLevel(View::LEVEL_MAIN_LAYOUT);
		else
	        $this->tag->setDocType(Tag::HTML5);

		$this->tag->setTitleSeparator(' :: ');
		$this->tag->setTitle(Options::get('site_title'));

		if (is_array($this->router->getParams()) && count($this->router->getParams()))
		{
			$params = $this->router->getParams();

			if (isset($params[0]) && is_numeric($params[0]))
				unset($params[0]);

			foreach ($params as $key => $value)
			{
				if (!is_numeric($key))
				{
					$_REQUEST[$key] = $_GET[$key] = $value;

					unset($params[$key]);
				}
			}

			$params = array_values($params);

			for ($i = 0; $i < count($params); $i += 2)
			{
				if (isset($params[$i]) && $params[$i] != '' && !is_numeric($params[$i]))
					$_REQUEST[$params[$i]] = $_GET[$params[$i]] = (isset($params[$i+1])) ? $params[$i+1] : '';
			}
		}

		$this->assets->addJs('assets/build/runtime.js', 'footer_js');

		$files = new DirectoryIterator(ROOT_PATH.'/public/assets/build/app/');

		foreach ($files as $file)
		{
			if (!$file->isFile())
				continue;

			if (strpos($file->getFilename(), '.css') !== false)
			{
				$sort = 100;

				if (strpos($file->getFilename(), 'bootstrap') !== false)
					$sort = 0;

				$this->assets->addCss('assets/build/app/'.$file->getFilename(), $sort);
			}
			else
			{
				$sort = 100;

				if (preg_match('_([0-9]+)_', $file->getFilename(), $match))
					$sort = (int) $match[1];

				$this->assets->addJs('assets/build/app/'.$file->getFilename(), ['collection' => 'footer_js', 'sort' => $sort]);
			}
		}

		Vars::init();

		Request::addData('route', [
			'controller' => $this->dispatcher->getControllerName(),
			'action' => $this->dispatcher->getActionName(),
		]);

		Request::addData('path', $this->url->getBaseUri());
		Request::addData('version', VERSION);
		Request::addData('host', $this->request->getHttpHost());
		Request::addData('redirect', '');
		Request::addData('messages', []);
		Request::addData('page', []);

		Request::addData('stats', [
			'time' => time(),
			'timezone' => (int) date('Z'),
			'online' => (int) Options::get('users_online', 0),
			'users' => (int) Options::get('users_total', 0),
		]);

		if ($this->auth->isAuthorized())
		{
			//if (!$this->user->isAdmin())
			//	die('Нельзя пока вам сюда');

			// Кэшируем настройки профиля в сессию
			if (!$this->session->has('config') || strlen($this->session->get('config')) < 10)
			{
				$inf = $this->db->query("SELECT settings FROM game_users_info WHERE id = " . $this->user->getId())->fetch();

				$this->session->set('config', $inf['settings']);
			}

			if (!(int) $this->config->view->get('showPlanetListSelect', 0))
				$this->config->view->offsetSet('showPlanetListSelect', $this->user->getUserOption('planetlistselect'));

			if ($this->request->getQuery('fullscreen') == 'Y')
			{
				$this->cookies->set($this->config->cookie->prefix."_full", "Y", (time() + 30 * 86400), "/", null, $_SERVER["SERVER_NAME"], 0);
				$_COOKIE[$this->config->cookie->prefix."_full"] = 'Y';
			}

			if ($this->request->getServer('SERVER_NAME') == 'vk.xnova.su')
			{
				$this->config->view->offsetSet('socialIframeView', 1);

				$this->assets->addJs('https://vk.com/js/api/xd_connection.js', 'footer');
			}

			if ($this->cookies->has($this->config->cookie->prefix."_full") && $this->cookies->get($this->config->cookie->prefix."_full") == 'Y')
			{
				$this->config->view->offsetSet('socialIframeView', 0);
				$this->config->view->offsetSet('showPlanetListSelect', 0);
			}

			// Заносим настройки профиля в основной массив
			$inf = json_decode($this->session->get('config'), true);

			if (is_array($inf))
				$this->user->setOptions($inf);

			if (!$this->user->getUserOption('chatbox'))
				$this->views['chat'] = false;

			$this->view->setVar('isPopup', ($this->request->has('popup') ? 1 : 0));
			$this->view->setVar('userId', $this->user->getId());

			if ($this->request->has('popup'))
				Request::addData('popup', true);

			if (!$this->request->isAjax())
			{
				$menu = [];

				foreach (_getText('main_menu') as $code => $data)
				{
					if ($data[2] > $this->user->authlevel)
						continue;

					$menu[] = [
						'id' => $code,
						'url' => $this->url->get($data[1]),
						'text' => trim($data[0]),
						'new' => isset($data[3])
					];
				}

				Request::addData('menu', $menu);
			}

			Request::addData('speed', [
				'game' => $this->game->getSpeed('build'),
				'fleet' => $this->game->getSpeed('fleet'),
				'resources' => $this->game->getSpeed('mine')
			]);

			Request::addData('page', false);
			Request::addData('error', false);

			$this->user->getAllyInfo();

			User::checkLevel($this->user);

			// Выставляем планету выбранную игроком из списка планет
			$this->user->setSelectedPlanet();

			$controller = $this->dispatcher->getControllerName();

			if (($this->user->race == 0 || $this->user->avatar == 0) && !in_array($controller, ['infos', 'content', 'start', 'error', 'logout']))
			{
				$this->view->disable();
				$this->response->redirect('start/');

				throw new \Exception(serialize(['controller' => 'start', 'action' => 'index']), 10);
			}
			elseif ($controller == 'index')
			{
				$this->view->disable();
				$this->response->redirect('overview/');

				throw new \Exception(serialize(['controller' => 'overview', 'action' => 'index']), 10);
			}
		}
		else
		{
			$this->showTopPanel(false);
			$this->showLeftPanel(false);

			if ($this->getDI()->has('game'))
				$this->game->checkReferLink();
		}

		return true;
	}

	public function afterExecuteRoute ()
	{
		if ($this->view->isDisabled())
			return true;

		$this->view->setVar('controller', $this->dispatcher->getControllerName().($this->dispatcher->getControllerName() == 'buildings' ? $this->dispatcher->getActionName() : ''));

		if (!$this->request->isAjax() && Request::getDataItem('redirect'))
			return $this->response->redirect(Request::getDataItem('redirect'));

		if ($this->auth->isAuthorized())
		{
			$messages = [];

			$globalMessage = Options::get('newsMessage', '');

			if ($globalMessage != '')
			{
				$messages[] = [
					'type' => 'warning-static',
					'text' => $globalMessage
				];
			}

			if ($this->user->deltime > 0)
			{
				$messages[] = [
					'type' => 'info-static',
					'text' => 'Включен режим удаления профиля!<br>Ваш аккаунт будет удалён после '.$this->game->datezone("d.m.Y", $this->user->deltime).' в '.$this->game->datezone("H:i:s", $this->user->deltime).'. Выключить режим удаления можно в настройках игры.'
				];
			}

			if ($this->user->vacation > 0)
			{
				$messages[] = [
					'type' => 'warning-static',
					'text' => 'Включен режим отпуска! Функциональность игры ограничена.'
				];
			}

			if ($this->flashSession->has())
			{
				foreach ($this->flashSession->getMessages() as $type => $items)
				{
					foreach ($items as $item)
					{
						$messages[] = [
							'type' => $type,
							'text' => $item
						];
					}
				}
			}

			Request::addData('messages', $messages);

			if ($this->user->messages_ally > 0 && $this->user->ally_id == 0)
			{
				$this->user->messages_ally = 0;
				$this->db->updateAsDict('game_users', ['messages_ally' => 0], "id = ".$this->user->id);
			}

			$planetsList = $this->cache->get('app::planetlist_'.$this->user->getId());

			if ($planetsList === null)
			{
				$planetsList = User::getPlanets($this->user->getId());

				if (count($planetsList))
					$this->cache->save('app::planetlist_'.$this->user->getId(), $planetsList, 600);
			}

			$planets = [];

			foreach ($planetsList as $item)
			{
				$planets[] = [
					'id' => (int) $item['id'],
					'name' => $item['name'],
					'image' => $item['image'],
					'g' => (int) $item['galaxy'],
					's' => (int) $item['system'],
					'p' => (int) $item['planet'],
					't' => (int) $item['planet_type'],
					'destroy' => $item['destruyed'] > 0,
				];
			}

			$quests = $this->cache->get('app::quests::'.$this->user->getId());

			if ($quests === null)
			{
				$quests = $this->db->query("SELECT COUNT(*) AS cnt FROM game_users_quests WHERE user_id = ".$this->user->id." AND finish = '1'")->fetch()['cnt'];

				$this->cache->save('app::quests::'.$this->user->getId(), $quests, 3600);
			}

			$user = [
				'id' => (int) $this->user->id,
				'name' => trim($this->user->username),
				'race' => (int) $this->user->race,
				'planet' => (int) $this->user->planet_current,
				'position' => false,
				'messages' => (int) $this->user->messages,
				'alliance' => [
					'id' => (int) $this->user->ally_id,
					'name' => $this->user->ally_name,
					'messages' => (int) $this->user->messages_ally
				],
				'planets' => $planets,
				'timezone' => (int) $this->user->getUserOption('timezone'),
				'color' => (int) $this->user->getUserOption('color'),
				'vacation' => $this->user->vacation > 0,
				'quests' => (int) $quests
			];

			if ($this->getDI()->has('planet'))
			{
				$user['position'] = [
					'galaxy' => (int) $this->planet->galaxy,
					'system' => (int) $this->planet->system,
					'planet' => (int) $this->planet->planet,
					'planet_type' => (int) $this->planet->planet_type,
				];
			}

			Request::addData('user', $user);

			Request::addData('chat', [
				'key' => md5($this->user->getId().'|'.$this->user->username.$this->config->chat->key),
				'server' => $this->config->chat->host.':'.$this->config->chat->port,
			]);

			Request::addData('resources', false);

			if ($this->getDI()->has('planet'))
				$this->topPlanetPanel();
			else
				$this->showTopPanel(false);
		}
		else
			$this->showTopPanel(false);

		Request::addData('view', $this->views);

		if (!$this->request->has('popup'))
			$this->tag->appendTitle(Options::get('site_title'));

		Request::addData('title', $this->tag->getTitle(false));
		Request::addData('url', $this->router->getRewriteUri());

		$this->view->setVar('options', Request::getData());

		return true;
	}

	public function topPlanetPanel ()
	{
		$data = [];

		foreach (Vars::getResources() AS $res)
		{
			$data[$res] = [
				'current' => floor(floatval($this->planet->{$res})),
				'max' => $this->planet->{$res.'_max'},
				'production' => 0,
				'power' => $this->planet->getBuild($res.'_mine')['power'] * 10
			];

			if ($this->user->vacation <= 0)
				$data[$res]['production'] = $this->planet->{$res.'_perhour'} + floor($this->config->game->get($res.'_basic_income', 0) * $this->config->game->get('resource_multiplier', 1));
		}

		$data['energy'] = [
			'current' => $this->planet->energy_max + $this->planet->energy_used,
			'max' => $this->planet->energy_max
		];

		$data['battery'] = [
			'current' => round($this->planet->energy_ak),
			'max' => $this->planet->battery_max,
			'power' => 0,
			'tooltip' => ''
		];

		$data['credits'] = (int) $this->user->credits;

		$data['officiers'] = [];

		foreach (Vars::getItemsByType(Vars::ITEM_TYPE_OFFICIER) AS $officier)
			$data['officiers'][$officier] = (int) $this->user->{Vars::getName($officier)};

		$data['battery']['power'] = ($this->planet->battery_max > 0 ? round($this->planet->energy_ak / $this->planet->battery_max, 2) * 100 : 0);
		$data['battery']['power'] = min(100, max(0, $data['battery']['power']));

		if ($data['battery']['power'] > 0 && $data['battery']['power'] < 100)
		{
			if (($this->planet->energy_max + $this->planet->energy_used) > 0)
				$data['battery']['tooltip'] .= 'Заряд: '.Format::time(round(((round(250 * $this->planet->getBuild('solar_plant')['level']) - $this->planet->energy_ak) / ($this->planet->energy_max + $this->planet->energy_used)) * 3600));
			elseif (($this->planet->energy_max + $this->planet->energy_used) < 0)
				$data['battery']['tooltip'] .= 'Разряд: '.Format::time(round(($this->planet->energy_ak / abs($this->planet->energy_max + $this->planet->energy_used)) * 3600));
		}

		Request::addData('resources', $data);
	}

	public function showTopPanel ($view = true)
	{
		$this->views['resources'] = $view;
	}

	public function showLeftPanel ($view = true)
	{
		$this->views['header'] = $view;
		$this->views['footer'] = $view;
		$this->views['menu'] = $view;
		$this->views['planets'] = $view;
	}
}