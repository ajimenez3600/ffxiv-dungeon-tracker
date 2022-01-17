<template>
<b-container fluid>
  <b-alert :variant="alert.variant" :show="alert.dismissCountdown" dismissible @dismissed="alert.dismissCountdown=0" @dismiss-count-down="countdownChanged">
    {{alert.message}}
  </b-alert>
  <b-form @submit=onSubmit>
    <section id="pre-instance">
      <b-form-row>
        <h3>Pre-Instance</h3>
      </b-form-row>
      <b-form-row>
        <label for="start_time">
          Start Time (*)
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The time you entered queue'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-input-group>
          <b-form-input id="start_time" type="datetime-local" required v-model="form.start_time" />
          <b-input-group-append>
            <b-btn variant=secondary @click="form.start_time = getCurrentDateTime()">Set Now</b-btn>
          </b-input-group-append>
        </b-input-group>
      </b-form-row>
      <b-form-row>
        <label for="roulette_name">
          Roulette Name
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Which roulette you\'re running, don\'t select an option if you\'re not running a roulette'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>        
        <b-form-select id="roulette_name" :options="roulettes" v-model="form.roulette_name" />
      </b-form-row>
      <b-form-row>
        <label for="job_name">
          Job Name (*)
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'What job are you running as? This is used for calculating queue time based on role.'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-select id="job_name" :options="jobs" required v-model="form.job_name" />
      </b-form-row>
      <b-form-row>
        <b-col cols=6>
          <label for="start_level">
            Starting Level (*)
            <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Your level at the time of entering the instance'">
              <i class='fas fa-question-circle'></i>
            </b-btn>
          </label>
          <b-form-input id="start_level" type="number" required min=1 v-model="form.start_level" />
        </b-col>
        <b-col cols=6>
          <label for="start_xp">
            Starting XP (*)
            <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Your experience in excess of your start level (what it says on your experience bar)'">
              <i class='fas fa-question-circle'></i>
            </b-btn>
          </label>
          <b-form-input id="start_xp" type="number" required min=0 v-model="form.start_xp" />
        </b-col>
      </b-form-row>
      <b-form-row>
        <label for="queue_pop_time">
          Queue Pop Time (*)
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The time you got your queue pop. If you have to re-enter queue, the time of your last queue pop.'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-input-group>
          <b-form-input id="queue_pop_time" type="datetime-local" required v-model="form.queue_pop_time" />
          <b-input-group-append>
            <b-btn variant=secondary @click="form.queue_pop_time = getCurrentDateTime()">Set Now</b-btn>
          </b-input-group-append>
        </b-input-group>
        <div class='form-warning' v-if="longQueue">
          It looks like you spent {{checkLongDuration(form.start_time, form.queue_pop_time)}} hours in queue, is that right?
        </div>
        <div v-if='negativeQueue' class='form-warning'>
          You seem to have been queued for a negative amount of time. Please take another look.
        </div>
      </b-form-row>
    </section>

    <section id="instance">
      <b-form-row>
        <h3>Instance (*)</h3>
        <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'What instance did you get?'">
          <i class='fas fa-question-circle'></i>
        </b-btn>
      </b-form-row>
      <div class='accordion' role=tablist>
        <b-card no-body class='mb-1' v-for='key in Object.keys(instances)' :key='key'>
          <b-card-header header-tag='header' class='p-1' role='tab'>
            <b-button v-if='instances[key] instanceof Array' block @click="() => $root.$emit('bv::toggle::collapse', key)">{{key}}</b-button>
            <div v-else>
              <h5 style='text-align: center;'>{{key}}</h5>
                <b-button-group style='width: 100%;'>
                  <b-button
                    class='mx-1'
                    v-for='key2 in Object.keys(instances[key])' :key="key2" 
                    @click="() => $root.$emit('bv::toggle::collapse', key + ' ' + key2)"
                  >
                    {{key2}}
                  </b-button>
                </b-button-group>
            </div>
          </b-card-header>
          <b-collapse v-if='instances[key] instanceof Array' :id='key' accordion='instances-accordion' role='tabpanel'>
            <b-card-body>
              <b-form-radio-group :options='instances[key]' stacked size='sm' v-model="form.instance_name" />
            </b-card-body>
          </b-collapse>
          <b-collapse v-else v-for='key2 in Object.keys(instances[key])' :key="key2" :id="key + ' ' + key2" accordion='instances-accordion' role='tabpanel'>
            <b-card-body>
              <b-form-radio-group :options='instances[key][key2]' stacked size='sm' v-model="form.instance_name" />
            </b-card-body>
          </b-collapse>
        </b-card>
      </div>
    </section>

    <section id='post-instance'>
      <b-form-row>
        <h3>Post-Instance</h3>
      </b-form-row>
      <b-form-row>
        <label for="finish_time">
          Finish Time (*)
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The time you exited the dungeon'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
          <b-input-group>
            <b-form-input id="finish_time" type="datetime-local" required v-model='form.finish_time' />
          <b-input-group-append>
            <b-btn variant=secondary @click="form.finish_time = getCurrentDateTime()">Set Now</b-btn>
          </b-input-group-append>
        </b-input-group>
        <div v-if='longInstance' class='form-warning'>
          It looks like you spent more than {{checkLongDuration(form.queue_pop_time, form.finish_time)}} hours in the instance, is that right?
        </div>
        <div v-if='negativeInstance' class='form-warning'>
          You seem to have been in the instance for a negative amount of time. Please take another look.
        </div>
      </b-form-row>
      <b-form-row>
        <b-col cols=6>
          <label for="finish_level">
            Finish Level (*)
            <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Your level at the time of exiting the dungeon'">
              <i class='fas fa-question-circle'></i>
            </b-btn>
          </label>
          <b-form-input id="finish_level" type="number" min=1 required v-model='form.finish_level' />
        </b-col>
        <b-col cols=6>
          <label for="finish_xp">
            Finish XP (*)
            <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Your experience in excess of your level at the time of exiting the dungeon (what it says on your experience bar)'">
              <i class='fas fa-question-circle'></i>
            </b-btn>
          </label>
          <b-form-input id="finish_xp" type="number" min=0 required v-model='form.finish_xp' />
        </b-col>
      </b-form-row>
      <b-form-row>
        <label for="xp_bonus">
          XP Bonus %
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The total experience bonus percent while you were in the dungeon. This will show up as a (+xxx%) every time you gain experience.'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="xp_bonus" type="number" v-model='form.xp_bonus' />
      </b-form-row>
      <b-form-row v-if="!!form.roulette_name">
        <label for="roulette_bonus">
          Roulette Bonus XP
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The experience you gained as a reward for participating in duty roulette'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="roulette_bonus" type="number" v-model='form.roulette_bonus' />
      </b-form-row>
      <b-form-row>
        <label for="new_player_bonus">
          New Player Bonus XP
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The experience you gained for swift first-time completion of duty objectives'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="new_player_bonus" type="number" v-model='form.new_player_bonus' />
      </b-form-row>
      <b-form-row>
        <label for="role_in_need_bonus">
          Role in Need Bonus XP
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'The experience you gained as a reward for being an adventurer-in-need'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="role_in_need_bonus" type="number" v-model='form.role_in_need_bonus' />
      </b-form-row>
      <b-form-row>
        <label for="other_bonus">
          Other Bonus XP
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Otherflat bonus XP bonuses. An example of this would be completing a challenge in the challenge log'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="other_bonus" type="number" v-model='form.other_bonus' />
      </b-form-row>
      <b-form-row>
        <label for="commends">
          Commends Received
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'I don\'t actually have a use for this data at time of writing, I\'m just interested.'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="commends" type="number" v-model='form.commends' />
      </b-form-row>
      <b-form-row>
        <b-input-group>
          <b-form-checkbox-group stacked v-model='form.outliers'>
            <b-form-checkbox value='queue_outlier'>
              Are you queuing with someone?
              <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Were you in a party when you queued? This will cause your queue time to not be weighed as heavily'">
                <i class='fas fa-question-circle'></i>
              </b-btn>
            </b-form-checkbox>
            <b-form-checkbox value='duration_outlier'>
              Did you join an in-progress group?
              <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Was the group you joined already partially done with the instance? This will cause your instance duration to not be counted.'">
                <i class='fas fa-question-circle'></i>
              </b-btn>
            </b-form-checkbox>
            <b-form-checkbox value='xp_outlier'>
              Did you hit level cap (or were at level cap before starting)?
              <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Were you at max level at the time of exiting the dungeon? This will cause your experience gain to not be weighed as heavily.'">
                <i class='fas fa-question-circle'></i>
              </b-btn>
            </b-form-checkbox>            
          </b-form-checkbox-group>
        </b-input-group>
      </b-form-row>      
      <b-form-row>
        <label for="notes">
          Notes
          <b-btn class='borderless' size=sm tabindex=-1 v-b-popover.hover.top="'Miscellany. This will not be displayed anywhere else on the site.'">
            <i class='fas fa-question-circle'></i>
          </b-btn>
        </label>
        <b-form-input id="notes" name='notes' v-model='form.notes' />
      </b-form-row>
    </section>

    <b-button class="my-3" variant=info type="submit" :disabled="!isValid" tabindex=-1 v-b-popover.hover.right="'Thank you!'" @click="goAgain=false">
      Submit
    </b-button>
    <b-button class="my-3" variant=info type="submit" :disabled="!isValid" tabindex=-1 v-b-popover.hover.right="'Thank you!'" @click="goAgain=true">
      Submit and Go Again
    </b-button>
  </b-form>
</b-container>
</template>

<script>
import CSRF from 'components/shared/csrf.vue';
import moment from 'moment';
import axios from 'axios';

export default {
  components: {
    csrf: CSRF,
  },
  props: {
    instances: {
      type: Object,
      default: () => {},
    },
    jobs: {
      type: Array,
      default: () => [],
    },
    roulettes: {
      type: Array,
      default: () => [],
    },
    csrf: {
      type: String,
      default: () => '',
    },
  },
  data() {
    return {
      form: { },
      alert: { },
      goAgain: false,
    };
  },
  computed: {
    longQueue() {
      return this.checkLongDuration(this.form.start_time, this.form.queue_pop_time) > 2
    },
    negativeQueue() {
      return this.checkLongDuration(this.form.start_time, this.form.queue_pop_time) < 0
    },
    longInstance() {
      return this.checkLongDuration(this.form.queue_pop_time, this.form.finish_time) > 2
    },
    negativeInstance() {
      return this.checkLongDuration(this.form.queue_pop_time, this.form.finish_time) < 0
    },
    isValid() {
      return !!this.form.instance_name
    },
  },
  mounted() {
    this.resetForm()
  },
  methods: {
    resetForm() {
      this.form = {
        start_time: undefined,
        roulette_name: undefined,
        job_name: this.goAgain ? this.form.job_name : undefined,
        start_level: this.goAgain ? this.form.finish_level : undefined,
        start_xp: this.goAgain ? this.form.finish_xp : undefined,
        queue_pop_time: undefined,
        instance_name: undefined,
        finish_time: undefined,
        finish_level: undefined,
        finish_xp: undefined,
        xp_bonus: undefined,
        roulette_bonus: undefined,
        new_player_bonus: undefined,
        role_in_need_bonus: undefined,
        other_bonus: undefined,
        commends: undefined,
        notes: undefined,
        outliers: [ ]
      };
    },
    getCurrentDateTime() {
      return moment().format('YYYY-MM-DDTHH:mm')
    },
    checkLongDuration(start, end) {
      if (!start || !end) {
        return false;
      }
      else {
        let start_parsed = moment(start, 'YYYY-MM-DDTHH:mm')
        let end_parsed = moment(end, 'YYYY-MM-DDTHH:mm')
        return end_parsed.diff(start_parsed, 'hours')
      }
    },
    onSubmit(event) {
      event.preventDefault();

      if (!!this.form.roulette_name) {
        this.form.roulette_bonus = 0;
      }
      this.form.utf8 = '✓';
      this.form.authenticity_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

      axios({
        method: 'POST',
        url: '/instance_entries',
        headers: {
          'Conten-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        data: this.form
      }).then(() => {
        this.resetForm();
        window.scrollTo(0,0);
        this.showSuccess();
      }).catch(error => {
        console.error(error);
        this.showError(error);
      })
    },
    showError() {
      this.alert = {
        variant: 'danger',
        show: true,
        dismissCountdown: 10,
        message: 'Something messed up, details have been logged to the console, but if the error persists, please contact me!'
      }
    },
    showSuccess() {
      this.alert = {
        variant: 'success',
        show: true,
        dismissCountdown: 10,
        message: 'Data submitted successfully, thank you!'
      }
    },
    countdownChanged(dismissCountdown) {
      this.alert.dismissCountdown = dismissCountdown;
    }
  }
};
</script>

<style scoped>
.borderless {
  color: #000;
  background-color: transparent;
  border-color: transparent;
  padding: 0px;
  margin: 0px;
}
.form-warning {
  margin-top: 0.25rem;
  font-size: 80%;
  color: #dc3545;
  width: 100%;
}
</style>
