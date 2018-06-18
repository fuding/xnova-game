import Vue from 'vue'
import Vuex from 'vuex'

import {state, mutations, actions, getters} from './module/app'

Vue.use(Vuex)

const store = new Vuex.Store({
	state,
	mutations,
	actions,
	getters
});

export default store