import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AiRecommendations } from './ai-recommendations';

describe('AiRecommendations', () => {
  let component: AiRecommendations;
  let fixture: ComponentFixture<AiRecommendations>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AiRecommendations],
    }).compileComponents();

    fixture = TestBed.createComponent(AiRecommendations);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
