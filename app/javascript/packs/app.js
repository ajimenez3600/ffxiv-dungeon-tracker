import Vue from 'vue/dist/vue.esm'

import Chart from 'chart.js/auto';
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

document.addEventListener('DOMContentLoaded', () => {
  var element = document.getElementById('dungeon-form')
  if (typeof(element) != 'undefined') {
    const app = new Vue({
      el: element,
      data: {
        jobs: JSON.parse(element.dataset.jobs),
        instances: JSON.parse(element.dataset.instances),
        roulettes: JSON.parse(element.dataset.roulettes),
      }
    })
  }

  element = document.getElementById('roulette-metrics')
  if (typeof(element) != 'undefined') {
    const app = new Vue({
      el: element,
      data: {
        entries: JSON.parse(element.data.entries),
      }
    })
  }

  element = document.getElementById('instance-type-metrics')
  if (typeof(element) != 'undefined') {
    const app = new Vue({
      el: element,
      data: {
      }
    })
  }

  element = document.getElementById('roulette-xp-calculator')
  if (typeof(element) != 'undefined') {
    const app = new Vue({
      el: element,
      data: {
      }
    })
  }
})
