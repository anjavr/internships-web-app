import { TestBed } from '@angular/core/testing';

import { Airecommendationservice } from './airecommendationservice';

describe('Airecommendationservice', () => {
  let service: Airecommendationservice;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Airecommendationservice);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
