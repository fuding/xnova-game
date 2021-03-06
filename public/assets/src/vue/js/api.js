import axios from 'axios'
import store from '../store'

const $api = axios.create({
	baseURL: store.state.path,
	timeout: 15000,
	headers: {'X-Requested-With': 'XMLHttpRequest'}
});

const $url = (url) => {
	return store.state.path+url.replace(/^\/+/g, '');
}

const $get = (url, data) =>
{
	return new Promise((resolve, reject) =>
	{
		if (data === undefined)
			data = {}

		data['_'] = Math.random()

		$api({
			method: 'get',
			url: url,
			params: data
		})
		.then(result =>
		{
			if (result.data.data !== undefined)
				resolve(result.data.data)
			else
				reject()
		})
		.catch((error) => {
			reject(error)
		})
	})
}

const $post = (url, data) =>
{
	return new Promise((resolve, reject) =>
	{
		let headers = {}

		if (data.toString().indexOf('FormData') < 0)
			data = $.param(data);
		else
			headers['Content-Type'] = 'multipart/form-data'

		$api({
			url: url,
			method: 'post',
			data: data,
			headers: headers
		})
		.then(result =>
		{
			if (result.data.data !== undefined)
				resolve(result.data.data)
			else
				reject()
		})
		.catch((error) => {
			reject(error)
		})
	})
}

export {
	$url,
	$api,
	$get,
	$post
}