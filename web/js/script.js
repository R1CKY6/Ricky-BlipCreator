const app = new Vue({
    el: '#app',
    data: {
        nomeRisorsa : GetParentResourceName(),


        selected : 'default',


        config: false,

        listaStili : [
            {
                nome: 'Default',
                id : 'default'
            },
            {
                nome : 'Gangster',
                id : 'gangster'
            }
        ]
    },

    methods: {

        updateSelected(selected) {
            this.selected = selected;
        },

        getStyle(id) {
            if(this.selected == id) {
                return {
                    backgroundImage : 'url(./img/aim_selected.png)'
                }
            } else {
                return {
                    backgroundImage : 'url(./img/aim_unselected.png)'
                }
            }
        },

        updateStili(stili) {
            this.listaStili = stili;
        },

        postMessage(type, data) {
            $.post(`https://${this.nomeRisorsa}/${type}`, JSON.stringify(data));
        },

        setNewStyle(id) {
            this.postMessage('setNewStyle', {
                id : id
            })
        },

        close() {
            $("#app").fadeOut(250)
            this.postMessage('close', {});
        },

        setConfig(config) {
            this.config = config;
        }
    }
});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        app.updateStili(data.stili)
        $("#app").show();
    } else if(data.type === "UPDATE_SELECTED") {
        app.updateSelected(data.selected);
    } else if(data.type === "SET_CONFIG") {
        app.setConfig(data.config)
    }
})


document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        app.close();
        return
    }
};
