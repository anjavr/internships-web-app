package com.praksa.backend.mapper;

import com.praksa.backend.dto.SkillDTO;
import com.praksa.backend.entity.Skill;

public class SkillMapper {

    public static SkillDTO toDTO(Skill skill) {
        SkillDTO skillDTO = new SkillDTO();
        skillDTO.setId(skill.getId());
        skillDTO.setName(skill.getName());
        skillDTO.setLevel(skill.getLevel());
        return skillDTO;
    }

    public static Skill toEntity(SkillDTO skillDTO) {
        Skill skill = new Skill();
        skill.setId(skillDTO.getId());
        skill.setName(skillDTO.getName());
        skill.setLevel(skillDTO.getLevel());
        return skill;
    }
}
