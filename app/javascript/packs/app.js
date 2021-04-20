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
  var navbar = document.getElementById('top-navbar')
  if (navbar !== null) {
    const navbarApp = new Vue({
      el: navbar,
    })
  }

  var dungeonForm = document.getElementById('dungeon-form')
  if (dungeonForm !== null) {
    const dungoenFormApp = new Vue({
      el: dungeonForm,
      data: {
        jobs: JSON.parse(dungeonForm.dataset.jobs),
        instances: JSON.parse(dungeonForm.dataset.instances),
        roulettes: JSON.parse(dungeonForm.dataset.roulettes),
      },
    })
  }

  var rouletteMetrics = document.getElementById('roulette-metrics')
  if (rouletteMetrics !== null) {
    const rouletteMetricsApp = new Vue({
      el: rouletteMetrics,
      data: {
        entries: JSON.parse(rouletteMetrics.dataset.entries),
        columns: JSON.parse(rouletteMetrics.dataset.columns)
      },
    })
  }

  var instanceMetrics = document.getElementById('instance-type-metrics')
  if (instanceMetrics !== null) {
    const instanceMetricsApp = new Vue({
      el: instanceMetrics,
      data: {
      }
    })
  }

  var xpCalculator = document.getElementById('roulette-xp-calculator')
  if (xpCalculator !== null) {
    const xpCalculatorApp = new Vue({
      el: xpCalculator,
      data: {
      }
    })
  }
})
