//
//  JsonBackup.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 21.07.24.
//

import Foundation

//Keeping json here just in case mock wont work
//[
//  {
//    "id": "1",
//    "name": "Bell Super",
//    "price": 249.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/736x/90/40/a1/9040a15209e0b16df13df85652e15173.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "2",
//    "name": "Fox Speedy",
//    "price": 199.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/736x/8b/39/28/8b39283501f2a8a787244b79091207f8.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "3",
//    "name": "Troy Lee A2",
//    "price": 179.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/a1/38/22/a13822735e53f0b7c7147494da6d88ad.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "4",
//    "name": "Spec Ambush",
//    "price": 219.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/65/4d/6b/654d6b8d7aca75816bf56d5b73e85511.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "5",
//    "name": "Bell Nomad",
//    "price": 99.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/90/40/a1/9040a15209e0b16df13df85652e15173.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "6",
//    "name": "POC Tectal",
//    "price": 239.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/11/12/58/11125899a8a25e78774dbf207635251f.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "7",
//    "name": "Abus Drop",
//    "price": 49.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/08/43/da/0843dad0d57a0dd21255e5278e9522e4.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "8",
//    "name": "Justtkit",
//    "price": 39.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/16/3d/14/163d148b1f0045d46f27ac07e05c0736.jpg",
//    "category": "Gloves",
//    "categoryImage": "https://i.pinimg.com/originals/28/49/dd/2849dd27a117e47ec3645d96a29df5f0.jpg"
//  },
//  {
//    "id": "9",
//    "name": "Rapha",
//    "price": 29.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/5e/d0/ec/5ed0ec4d24293912585ebc866e1c8ba4.jpg",
//    "category": "Gloves",
//    "categoryImage": "https://i.pinimg.com/originals/28/49/dd/2849dd27a117e47ec3645d96a29df5f0.jpg"
//  },
//  {
//    "id": "10",
//    "name": "Bell Super",
//    "price": 249.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/736x/90/40/a1/9040a15209e0b16df13df85652e15173.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "11",
//    "name": "Fox Speedy",
//    "price": 199.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/736x/8b/39/28/8b39283501f2a8a787244b79091207f8.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "12",
//    "name": "Troy Lee A2",
//    "price": 179.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/a1/38/22/a13822735e53f0b7c7147494da6d88ad.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "13",
//    "name": "Spec Ambush",
//    "price": 219.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/65/4d/6b/654d6b8d7aca75816bf56d5b73e85511.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "14",
//    "name": "Bell Nomad",
//    "price": 99.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/90/40/a1/9040a15209e0b16df13df85652e15173.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "15",
//    "name": "POC Tectal",
//    "price": 239.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/11/12/58/11125899a8a25e78774dbf207635251f.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "16",
//    "name": "Abus Drop",
//    "price": 49.99,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/08/43/da/0843dad0d57a0dd21255e5278e9522e4.jpg",
//    "category": "Helmets",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "17",
//    "name": "Altuna",
//    "price": 27.50,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/37/3c/8b/373c8b62c5b4a702e1b0ed39ad7d0f4a.jpg",
//    "category": "Gloves",
//    "categoryImage": "https://i.pinimg.com/originals/28/49/dd/2849dd27a117e47ec3645d96a29df5f0.jpg"
//  },
//  {
//    "id": "18",
//    "name": "Altura",
//    "price": 35.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/25/d4/40/25d440c4a60ecb6957b0c7e6e24f9423.jpg",
//    "category": "Gloves",
//    "categoryImage": "https://i.pinimg.com/originals/28/49/dd/2849dd27a117e47ec3645d96a29df5f0.jpg"
//  },
//  {
//    "id": "19",
//    "name": "Tatonka Hiking",
//    "price": 55.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/36/ea/21/36ea21af54737bc4311034048c82b05c.jpg",
//    "category": "Bags",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "20",
//    "name": "Backpack Water Proof",
//    "price": 75.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/59/85/bc/5985bca8d16dbde8e4c6a47ae4e3d3d8.jpg",
//    "category": "Bags",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "21",
//    "name": "Military",
//    "price": 45.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/95/85/bd/9585bd2e7d0de98e4c6a47ae4e3d3d8.jpg",
//    "category": "Bags",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "22",
//    "name": "Hiking Pro",
//    "price": 65.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/63/ea/1c/63ea1c54737bc4311034048c82b05c.jpg",
//    "category": "Bags",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  },
//  {
//    "id": "23",
//    "name": "Adventure Pack",
//    "price": 55.00,
//    "quantity": 0,
//    "image": "https://i.pinimg.com/originals/69/55/bc/6955bca8d16dbde8e4c6a47ae4e3d3d8.jpg",
//    "category": "Bags",
//    "categoryImage": "https://i.pinimg.com/originals/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
//  }
//]
