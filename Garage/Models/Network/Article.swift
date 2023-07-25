//
//  Article.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//

import Foundation

struct Article: Decodable {
    let id: Int
    let title: String
    let text: String
}

extension Article {
    static let test = Article(
        id: 1,
        title: "Чем реже, тем лучше: как часто нужно менять моторное масло?",
        text: """
        Происхождение двух последних чисел очевидно: их чаще всего называют в сервисных книжках производители автомобилей. Правда, при этом часто бывает оговорка: в тяжёлых условиях эксплуатации интервал желательно сократить. И вот тут появляются те самые семь или восемь тысяч «от замены до замены». В общем-то, появляются они не случайно: в ходе эксплуатации масло в моторе стареет. Этот процесс неизбежен по нескольким очевидным причинам. Высокие температуры, картерные газы, неизбежное разжижение топливом, твёрдые частицы (продукты износа мотора) потихоньку приводят масло в негодность. В нём изнашивается пакет присадок, под действием кислот (которые есть, например, в картерных газах из-за наличия там влаги и оксидов серы и азота) изменяются характеристики основы – базового масла, и в результате свойства масла меняются. Деградация масла приводит к тому, что оно уже не способно эффективно выполнять все три основные задачи: охлаждать, смазывать и очищать. Вот только не совсем понятно, как быстро масло приходит в негодность?
        """
    )
}

struct News: Decodable {
    let count: Int
    let next: Int?
    let previous: Int?
    let results: [Article]
}
