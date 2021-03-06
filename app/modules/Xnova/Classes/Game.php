<?php

namespace Xnova;

/**
 * @author AlexPro
 * @copyright 2008 - 2018 XNova Game Group
 * Telegram: @alexprowars, Skype: alexprowars, Email: alexprowars@gmail.com
 */

use Phalcon\Mvc\User\Component;
use Xnova\Models\User;

/**
 * Class ControllerBase
 * @property \Phalcon\Mvc\View view
 * @property \Phalcon\Tag tag
 * @property \Phalcon\Assets\Manager assets
 * @property \Phalcon\Db\Adapter\Pdo\Mysql db
 * @property \Phalcon\Mvc\Model\Manager modelsManager
 * @property \Phalcon\Session\Adapter\Memcache session
 * @property \Phalcon\Http\Response\Cookies cookies
 * @property \Phalcon\Http\Request request
 * @property \Phalcon\Http\Response response
 * @property \Phalcon\Mvc\Router router
 * @property \Phalcon\Cache\Backend\Memcache cache
 * @property \Phalcon\Mvc\Url url
 * @property \Xnova\Models\User user
 * @property \Friday\Core\Auth\Auth auth
 * @property \Phalcon\Mvc\Dispatcher dispatcher
 * @property \Phalcon\Flash\Direct flash
 * @property \Phalcon\Registry|\stdClass storage
 * @property \Phalcon\Config|\stdClass config
 * @property \Xnova\Game game
 */
class Game extends Component
{
	function datezone ($format, $time = 0)
	{
		if ($time == 0)
			$time = time();

		if ($this->di->has('user') && !is_null($this->user->getUserOption('timezone')))
			$time += $this->user->getUserOption('timezone') * 1800;

		return date($format, $time);
	}

	public function getSpeed ($type = '')
	{
		if ($type == 'fleet')
			return (int) $this->config->game->get('fleet_speed', 2500) / 2500;
		if ($type == 'mine')
			return (int) $this->config->game->get('resource_multiplier', 1);
		if ($type == 'build')
			return round((int) $this->config->game->get('game_speed', 2500) / 2500, 1);

		return 1;
	}

	public function checkReferLink ()
	{
		if (!$this->session->has('uid') && is_numeric($this->request->getServer('QUERY_STRING')) && strlen($this->request->getServer('QUERY_STRING')) > 0)
		{
			$id = intval($this->request->getServer('QUERY_STRING'));

			$user = User::findFirst($id);

			if ($user)
			{
				$ip = sprintf("%u", ip2long($this->request->getClientAddress()));

				$res = $this->db->fetchOne("SELECT `id` FROM game_moneys where `ip` = '" . $ip . "' AND `time` > '" . (time() - 86400) . "'");

				if (!isset($res['id']))
				{
					$this->db->insertAsDict(
						"game_moneys",
						[
							'user_id'		=> $user->id,
							'time'			=> time(),
							'ip'			=> $ip,
							'referer'		=> $this->request->hasServer('HTTP_REFERER') ? $this->request->getServer('HTTP_REFERER') : '',
							'user_agent'	=> $this->request->getServer('HTTP_USER_AGENT'),
						]
					);

					$user->links++;
					$user->refers++;
					$user->update();
				}

				$this->session->set('ref', $user->id);
			}
		}
	}
}