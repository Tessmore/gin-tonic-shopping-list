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

<!--         <div class="full">
            <small>€€ is an estimate of the Gin (bottles between €22,00 - 45,00), Tonic (€2,-) and any extra's.</small>
        </div>
 -->
    </div>

    <div style="clear:both;"></div>
  </div>
</template>

<script>
import data from "./data/recipes.json5"
import deburr from "lodash.deburr"


var priceTag = function(price) {
    var r = "";

    if (price === "-" || price === "?") {
      return "?"
    }


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

                // Include spelling mistakes / alternative spellings
                if (item.alt_names) {
                    item.label += " " + item.alt_names.map(s => normalize(s)).join(" ");
                }

                return item;
            })
        }
    },

    computed: {
        filtered: function() {
            var searchStr = normalize(this.filter||"");

            var items = this.items.filter((item) => {
                if (!item.name) {
                    return false;
                }

                if (!searchStr || searchStr.length < 2) {
                    return true;
                }

                return item.label.includes(searchStr);
            });


            // Default: Sort alphabetical
            items = items.sort(function(a, b) {
                return a.name.localeCompare(b.name);
            });


            // Filter active (prefix match better)
            if (searchStr && searchStr.length > 1) {
                var prefix = searchStr.slice(0, 3);

                items = items.sort(function(a, b) {
                    if (a.label && a.label.startsWith(prefix)) {
                        return -1;
                    }

                    if (b.label && b.label.startsWith(prefix)) {
                        return  1;
                    }

                    return 0;
                });
            }

            return items;
        }
    }
}
</script>
