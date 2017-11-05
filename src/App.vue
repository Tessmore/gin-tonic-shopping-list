<template>
  <div id="app" class="wrapper">
      <div class="content">
        <div class="full header">
          <h1 class="title">
            Gin <span class="amp">&amp;</span> Tonics
          </h1>

          <div class="full search">
              <div class="left">
                  <input type="text" v-model="filter" placeholder="Filter...">
              </div>
          </div>
        </div>

        <div class="full">
            <div v-for="item in filtered" class="item">
                <h3 class="full">
                  <span class="left">{{ item.name }}</span>

                  <span class="right price">{{ item.price_tag }}</span>
                </h3>

                <ul class="full item-list">
                    <li v-for="obj in item.goes_with">
                      <strong>{{ obj.tonic }}</strong>

                      <span v-for="g in obj.extra">{{ g }}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div style="clear:both;"></div>
  </div>
</template>

<script>
import data from "./data/recipes.json5"
import deburr from "lodash.deburr"


var priceTag = function(price) {
    var r = "";

    if (price < 14) {
        return "€";
    }
    else if (price <= 18) {
        r = "€€";

    }
    else if (price <= 22) {
        r = "€€€";
    }
    else {
        r = "€€€€";
    }

    return r;
};

var normalize = function(text) {
    if (!text) {
        return "";
    }

    return deburr(text).toLowerCase()
      .replace("'", "")
      .replace(/[\-\.]/g, " ")
      .trim();
};


export default {
    name: 'app',

    data () {
        return {
            filter : "",

            items: data.gin_tonics.map(function(item) {
                item.price_tag = priceTag(item.pricing);

                // Create label for comparison
                item.label = normalize(item.name);

                return item;
            })
        }
    },

    computed: {
        filtered: function() {
            var items = this.items.filter((item) => {
                if (!item.name) {
                    return false;
                }

                if (!this.filter || this.filter.length < 2) {
                    return true;
                }


                var searchStr = normalize(this.filter);
                return item.label.includes(searchStr);
            });


            // Default: Sort alphabetical
            items = items.sort(function(a, b) {
                return a.name.localeCompare(b.name);
            });


            // Filter active (prefix match better)
            if (this.filter && this.filter.length > 2) {

            }

            return items;
        }
    }
}
</script>
