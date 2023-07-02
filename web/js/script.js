const app = new Vue({
    el: '#app',
    data: {
        
        nomeRisorsa : GetParentResourceName(),

        viewNotify : false,


        config : false,

        numeriDisplay : [
            {
                numero : 0,
                description : 'Non compare, mai, da nessuna parte.'
            },
            {
                numero : 1,
                description : 'Non compare, mai, da nessuna parte.'
            },
            {
                numero : 2,
                description : 'Mostra sia sulla mappa principale che sulla minimappa.'
            },
            {
                numero : 3,
                description : 'Mostra solo sulla mappa principale.'
            },
            {
                numero : 4,
                description : 'Mostra solo sulla mappa principale.'
            },
            {
                numero : 5,
                description : 'Mostra solo sulla minimappa.'
            },
            {
                numero : 6,
                description : 'Mostra sia sulla mappa principale che sulla minimappa.'
            },
            {
                numero : 7,
                description : 'Non compare, mai, da nessuna parte.'
            },
            {
                numero : 8,
                description : 'Mostra sia sulla mappa principale che sulla minimappa. (Non selezionabile dalla mappa)'
            },
            {
                numero : 9,
                description : 'Mostra solo sulla minimappa.'
            },
            {
                numero : 10,
                description : 'Mostra sia sulla mappa principale che sulla minimappa. (Non selezionabile sulla mappa).'
            },
        ],

        listaBlip : [
            {
                nome : 'Blip 1',
                id : 1,
                sprite : 57,
                color : '5',
                display : '7',
                coords : {
                    x : 0,
                    y : 0,
                    z : 0
                }
            }
        ],

        blipSelected : false,
    },

    methods : {

        postNUI(type, data) {
            $.post(`https://${this.nomeRisorsa}/${type}`, JSON.stringify(data), function (datab) {
                return datab;
            });
        },

        notify(msg, type, number) {
            if(!type) {
                type = "success"
            }

            if(!number) {
                number = 0
            }

            if(type == 'success') {
                $(".notify").css("background-color", "rgba(0, 255, 0, 0.5)")
            } else {
                $(".notify").css("background-color", "rgba(255, 0, 0, 0.5)")
            }

            $(".notify").html(`<span>${msg}</span>`)

            if(this.viewNotify == true) {
                return 
            }

            $(".notify").show()
            this.viewNotify = true

            setTimeout(() => {
                document.getElementsByClassName("notify")[number].classList.add("from-bottom-to-top")
                setTimeout(() => {
                    $(".notify").hide()
                    this.viewNotify = false
                    document.getElementsByClassName("notify")[number].classList.remove("from-bottom-to-top")
                }, 300);
            }, 3000);
        },
        

        clearAllInput() {
            var inputs = document.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].value = "";
            }

        },

        infoBlip(id) {
            if(this.blipSelected != false) {
                if(!this.blipSelected.id == id) {
                    this.clearAllInput()
                }
            } else {
                this.clearAllInput()
            }
            this.closeViewDisplay()
            let blip = this.listaBlip.find( blip => blip.id == id );
            this.blipSelected = blip;
            $(".containerCreateBlip").fadeOut(500);
            $(".containerGestioneBlip").fadeIn(500);
        },

        viewInfoDisplay() {
            $(".infoDisplay").fadeIn(500);
        },

        closeViewDisplay() {
            $(".immagine").html("")
            if(this.config == false) {
                return 
            }
            document.getElementsByClassName("immagine")[1].innerHTML = ""
            $(".infoDisplay").fadeOut(500);
        },

        setMyCoords() {
            this.postNUI('setMyCoords');
            $(".newPosition").val("Coordinate")
        },

        updateNewCoords(coords) {
            $(".newPosition").val(`${coords.x}, ${coords.y}, ${coords.z}`)
            document.getElementsByClassName("newPosition")[1].value = `${coords.x}, ${coords.y}, ${coords.z}`
        },

        createBlip() {
            var name = $(".newBlipName").val();
            var sprite = $(".newSprite").val();
            var color = $(".newColor").val();
            var display = $(".newDisplay").val();
            var coords = $(".newPosition").val();

            if(name == '') {
                this.notify(this.config.Translate.error_name, "error", 0)
                return
            } else if(sprite == '') {
                this.notify(this.config.Translate.error_sprite, "error", 0)
                return
            } else if(color == '') {
                this.notify(this.config.Translate.error_color, "error", 0)
                return
            } else if(display == '') {
                this.notify(this.config.Translate.error_display, "error", 0)
                return
            } else if(coords == '') {
                this.notify(this.config.Translate.error_coords, "error", 0)
                return
            }
            
            this.postNUI('createBlip', {
                name : name,
                sprite : sprite,
                color : color,
                display : display,
                coords : coords
            });
            
            this.notify(this.config.Translate.blip_created, "success", 0)
            this.clearAllInput()
        },

        updateCreatedBlip(blip) {
            this.listaBlip = blip

            if(this.blipSelected != false) {
                let blip = this.listaBlip.find( blip => blip.id == this.blipSelected.id );
                this.blipSelected = blip;
            }
        },

        deleteBlip(NOTclear) {
            if(NOTclear == undefined || NOTclear == false || NOTclear == null || NOTclear == "" || !NOTclear) {
                app.clearAllInput()
            }
            this.blipSelected = false;
            $(".containerCreateBlip").fadeIn(500);
            $(".containerGestioneBlip").fadeOut(500);
            this.postNUI('deleteBlip', {
                id : this.blipSelected.id
            })
        },

        setDisplayNumero(numero) {
            $(".newDisplay").val(numero)
            for(let i = 0; i < this.numeriDisplay.length; i++) {
                if(this.numeriDisplay[i].numero == numero) {
                    $(".immagine").html(this.numeriDisplay[i].description)
                    document.getElementsByClassName("immagine")[1].innerHTML = this.numeriDisplay[i].description
                }
            }

        },

        applyModify() {
            var name = document.getElementsByClassName("newBlipName")[1].value;
            var sprite = document.getElementsByClassName("newSprite")[1].value;
            var color = document.getElementsByClassName("newColor")[1].value;
            var display = document.getElementsByClassName("newDisplay")[1].value;
            var coords = document.getElementsByClassName("newPosition")[1].value;

            if(name == '') {
                this.notify(this.config.Translate.error_name, "error", 1)
                return
            } else if(sprite == '') {
                this.notify(this.config.Translate.error_sprite, "error", 1)
                return
            } else if(color == '') {
                this.notify(this.config.Translate.error_color, "error", 1)
                return
            } else if(display == '') {
                this.notify(this.config.Translate.error_display, "error", 1)
                return
            } else if(coords == '') {
                this.notify(this.config.Translate.error_coords, "error", 1)
                return
            }

            this.postNUI('editBlip', {
                idBlip : this.blipSelected.id,
                name : name,
                sprite : sprite,
                color : color,
                display : display,
                coords : coords
            });
            this.notify(this.config.Translate.blip_updated, "success", 1)
        },

        openURL(url) {
            window.invokeNative('openUrl', url);
        },

        viewInfoColor() {
            this.openURL("https://docs.fivem.net/docs/game-references/blips/#blip-colors")
        },

        viewInfoSprite() {
            this.openURL("https://docs.fivem.net/docs/game-references/blips")
        },

        setConfig(config) {
            this.config = config
            this.config.Translate = this.config.Translate[config.Language]
        }
    }
});


document.onkeyup = function (data) {
    if (data.key == 'Escape' && app.blipSelected != false) {
        app.clearAllInput()
        $(".containerCreateBlip").fadeIn(500);
        $(".containerGestioneBlip").fadeOut(500);
        setTimeout(() => {
            app.blipSelected = false;            
        }, 400);
    } else if (data.key == 'Escape' && app.blipSelected == false) {
        $("#app").fadeOut(500)
        app.postNUI('close')
    }
};

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        app.clearAllInput()
        app.closeViewDisplay()
        $("#app").fadeIn(500);
        app.updateCreatedBlip(data.createdBlip);
    } else if(data.type == "SET_COORDS") {
        app.updateNewCoords(data.coords);
    } else if(data.type == "UPDATE_CREATED_BLIP") {
        app.closeViewDisplay()
        app.updateCreatedBlip(data.createdBlip);
    } else if(data.type == "SET_CONFIG") {
        app.setConfig(data.config)
    }
})
