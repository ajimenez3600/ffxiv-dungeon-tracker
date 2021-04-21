import Vue from 'vue/dist/vue.esm'

import Chart, { registerables } from 'chart.js/auto';
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
    const entries = JSON.parse(rouletteMetrics.dataset.entries);
    const rouletteMetricsApp = new Vue({
      el: rouletteMetrics,
      data: {
        entries: entries,
        columns: JSON.parse(rouletteMetrics.dataset.columns)
      },
    })

    var colors = [
      { border: 'rgba(255,0,0,255)',    background: 'rgba(255,0,0,100)' },     // red
      { border: 'rgba(255,51,0,255)',   background: 'rgba(255,51,0,100)' },    // orange
      { border: 'rgba(255,204,0,255)',  background: 'rgba(255,204,0,100)' },   // yellow
      { border: 'rgba(51,153,0,255)',   background: 'rgba(51,153,0,100)' },    // green
      { border: 'rgba(51,102,255,255)', background: 'rgba(51,102,255,100)' },  // blue
      { border: 'rgba(51,51,255,255)',  background: 'rgba(51,51,255,100)' },   // indigo
      { border: 'rgba(102,51,255,255)', background: 'rgba(102,51,255,100)' },  // purple
      { border: 'rgba(204,153,51,255)', background: 'rgba(204,153,51,100)' },  // brown
    ]

    var data = { }
    Object.keys(entries).forEach((level) => {
      var number = entries[level]['level']
      var roulettes = Object.keys(entries[level]).slice(1)
      roulettes.forEach((roulette) => {
        if (!data.hasOwnProperty(roulette)) {
          data[roulette] = [ ]
        }
        entries[level][roulette]['raw'].forEach((entry) => {
          data[roulette].push({ x:number, y:entry })
        })
      })
    })

    var set = Object.keys(data).map((k, i) => {
      return ({
        label: k,
        data: data[k],
        borderColor: colors[i]['border'],
        backgroundColor: colors[i]['background']
      })
    });

    var ctx = document.getElementById('scatterplot');
    var scatterplot = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: set,
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
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
