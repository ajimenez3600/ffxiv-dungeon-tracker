<template>
<section>
  <b-form method="POST" action="/instance_entries">
    <section id="pre-instance">
      <b-form-row>
        <h3>Pre-Instance</h3>
      </b-form-row>
      <b-form-row>
        <label for="start_time">Start Time</label>
        <b-form-input required id="start_time" type="datetime-local" v-model="form.startTime" />
      </b-form-row>
      <b-form-row>
        <label for="roulette_name">Roulette Name</label>
        <b-form-select id="roulette_name" options="roulettes" v-model="form.rouletteName" />
      </b-form-row>
      <b-form-row>
        <label for="job_name">Job Name</label>
        <b-form-select required id="job_name" :options="jobs" v-model="form.jobName" />
      </b-form-row>
      <b-form-row>
        <b-col cols=6>
          <label for="start_level">Starting Level</label>
          <b-form-input required id="start_level" type="number" v-model="form.startLevel" />
        </b-col>
        <b-col cols=6>
          <label for="start_xp">Starting XP</label>
          <b-form-input required id="start_xp" type="number" v-model="form.startXp" />
        </b-col>
      </b-form-row>
      <b-form-row>
        <label for="queue_pop_time">Queue Pop Time</label>
        <b-form-input required id="queue_pop_time" type="datetime-local" v-model="form.queuePopTime" />
      </b-form-row>
    </section>

    <section>
      <b-form-row>
        <h3>Instance</h3>
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
              <b-form-radio-group required :options='instances[key]' stacked size='sm' />
            </b-card-body>
          </b-collapse>
          <b-collapse v-else v-for='key2 in Object.keys(instances[key])' :key="key2" :id="key + ' ' + key2" accordion='instances-accordion' role='tabpanel'>
            <b-card-body>
              <b-form-radio-group required :options='instances[key][key2]' stacked size='sm' />
            </b-card-body>
          </b-collapse>
        </b-card>
      </div>
    </section>

    <section id='instance'>
      <b-form-row>
        <h3>Post-Instance</h3>
      </b-form-row>
      <b-form-row>
        <label for="finish_time">Finish Time</label>
        <b-form-input required id="finish_time" type="datetime-local" v-model='finishTime' />
      </b-form-row>
      <b-form-row>
        <b-col cols=6>
          <label for="finish_level">Finish Level</label>
          <b-form-input required id="finish_level" type="number" v-model='finishLevel' />
        </b-col>
        <b-col cols=6>
          <label for="finish_xp">Finish XP</label>
          <b-form-input required id="finish_xp" type="number" v-model='finishXp'>
        </b-col>
      </b-form-row>
      <b-form-row>
        <label for="xp_bonus">XP Bonus %</label>
        <b-form-input id="xp_bonus" type="number" v-model='xpBonusPercent' />
      </b-form-row>
      <b-form-row>
        <label for="roulette_bonus">Roulette Bonus XP</label>
        <b-form-input id="roulette_bonus" type="number" v-model='rouletteBonus' />
      </b-form-row>
      <b-form-row>
        <label for="new_player_bonus">New Player Bonus XP</label>
        <b-form-input id="new_player_bonus" type="number" v-model='newPlayerBonus' />
      </b-form-row>
      <b-form-row>
        <label for="role_in_need_bonus">Role in Need Bonus XP</label>
        <b-form-input id="role_in_need_bonus" type="number" v-model='roleInNeedBonus' />
      </b-form-row>
      <b-form-row>
        <label for="other_bonus">Other Bonus XP</label>
        <b-form-input id="other_bonus" type="number" v-model='otherBonus' />
      </b-form-row>
      <b-form-row>
        <label for="commends">Commends Received</label>
        <b-form-input id="commends" type="number" v-model='commends' />
      </b-form-row>
      <b-form-row>
        <div role="group" tabindex="-1" class="bv-no-focus-ring">
          <div class="custom-control custom-checkbox">
            <b-form-input type="checkbox" name='queue_outlier' class="custom-control-b-form-input" value="Are you queueing with someone?" id="option-0">
            <label class="custom-control-label" for="option-0">
              <span>Are you queueing with someone?</span>
            </label>
          </div>
          <div class="custom-control custom-checkbox">
            <b-form-input type="checkbox" name='duration_outlier' class="custom-control-b-form-input" value="Did you join an in-prog?" id="option-1">
            <label class="custom-control-label" for="option-1">
              <span>Did you join an in-prog?</span>
            </label>
          </div>
          <div class="custom-control custom-checkbox">
            <b-form-input type="checkbox" name='xp_outlier' class="custom-control-b-form-input" value="Did you hit level cap (or were at cap before starting)?" id="option-2">
            <label class="custom-control-label" for="option-2">
              <span>Did you hit level cap (or were at cap before starting)?</span>
            </label>
          </div>
        </div>
      </b-form-row>      
      <b-form-row>
        <label for="notes">Notes</label>
        <b-form-input id="notes" name='notes' />
      </b-form-row>
    </section>

    <b-button class="my-3" variant=info type=submit>Submit</b-button>
  </b-form>
</section>
</template>

<script>
import CSRF from 'components/shared/csrf.vue';

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
  },
  data() {
    return {
      form: {
        startTime,
        rouletteName,
        jobName,
        startingLevel,
        startingXp,
        queuePopTime,
        instanceName,
        finishTime,
        finishLevel,
        finishXp,
        xpBonusPercent,
        rouletteBonus,
        newPlayerBonus,
        roleInNeedBonus,
        otherBonus,
        commends,
        outliers: [ ]
      }
    };
  },
};
</script>

<style scoped>
</style>
