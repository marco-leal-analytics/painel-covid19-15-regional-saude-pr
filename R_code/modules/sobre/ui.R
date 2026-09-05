################################################################################################################
######################################## MODULO: SOBRE (UI) ###################################################
################################################################################################################
# Pagina "Sobre" e um documento Quarto estatico (sobre.qmd -> sobre.html),
# incorporado via iframe. Sem controles reativos.

sobreUI <- function(id) {
  ns <- NS(id)

  document_path <- file.path("R_code", "modules", "sobre", "sobre.html")
  document_mtime <- file.info(document_path)$mtime
  document_version <- if (is.na(document_mtime)) "latest" else format(document_mtime, "%Y%m%d%H%M%S")

  tags$div(class = "qmd-home-wrapper",
    tags$section(class = "resume-main qmd-document-shell",
      tags$iframe(
        class = "qmd-document-frame",
        src = paste0("sobre-document/sobre.html?v=", document_version),
        title = "Sobre o painel",
        scrolling = "auto",
        style = "width: 100%; border: 0;",
        onload = paste0(
          "var frame=this;",
          "var resize=function(){var doc=frame.contentWindow.document;",
          "frame.style.height=Math.max(doc.documentElement.scrollHeight,doc.body.scrollHeight)+'px';};",
          "resize();",
          "if(frame.contentWindow.ResizeObserver){",
          "new frame.contentWindow.ResizeObserver(resize).observe(frame.contentWindow.document.documentElement);",
          "} else {setTimeout(resize,100);setTimeout(resize,500);}"
        )
      )
    )
  )
}
