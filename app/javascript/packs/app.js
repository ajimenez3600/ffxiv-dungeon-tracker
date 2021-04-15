/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

// document.addEventListener('DOMContentLoaded', () => {
//   //Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name=csrf-token"]').getAttribute('content')

//   var element = document.getElementById('dungeon-form')
//   if (element != null) {
//     var d = JSON.parse(element.dataset.jobs)
//     var app = new Vue({
//       el: element,
//       data() {
//         return { jobs: d, dat: '' }
//       }
//     })
//     console.log(app)
//   }
// })


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  var element = document.getElementById('dungeon-form')
  var jobs = JSON.parse(element.dataset.jobs)
  var instances = JSON.parse(element.dataset.instances)
  const app = new Vue({
    el: element,
    data: {
      jobs,
      instances,
    },
    components: { App }
  })
})
