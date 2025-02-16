import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fetch-dishes"
export default class extends Controller {
  static values = {
    menuDishes: Array
  }
  static targets = ["swipers"]

  connect() {
    this.menuDishesValue.forEach(dish => {
      fetch(`${window.location.origin}/image_search?dish_id=${dish}`)
        .then(response => response.json())
        .then((data) => {

          let photoHTML = "";
          data.photo.forEach ((photo) => {
            photoHTML +=
            `<swiper-slide class="swip-slid">
              <div class="card-category" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url('${photo['url']}')">
                ${data.dish["title"]}
              </div>
            </swiper-slide>`
          })

          this.swipersTarget.insertAdjacentHTML("beforeend",
          `<a class="text-decoration-none" href="/dishes/${data.dish["id"]}">
            <swiper-container navigation="false" class="my-swiper col-12 col-lg-4" pagination="true" scrollbar="false" effect="coverflow">
              ${photoHTML}
            </swiper-container>
          </a>`
          )
        });

    });
  }
}


// `<swiper-container navigation="false" class="my-swiper col-12 col-lg-4" pagination="true" scrollbar="false" effect="coverflow">
// data.photo.forEach ((photo) => {
//     <swiper-slide class="swip-slid">
//       <div class="card-category" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url(photo[:url])">
//         data.dish[:title]
//       </div>
//   })
//     </swiper-slide>
// </swiper-container>`
