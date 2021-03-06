import React from 'react';
import { browserHistory, Link } from 'react-router';

const TripShow = (props) => {
  let background_image = {backgroundImage: `url(${props.image})`, backgroundSize: 'cover', backgroundPosition: 'center' };

  return(    
    <div className="jumbotron jumbotron-fluid" style={background_image}>
      <div className="container">
        <h1 className="display-4 trip-name">{props.name}</h1>
        <p className="lead trip-description">{props.description}</p>
      </div>
    </div>    
  )
}

export default TripShow;