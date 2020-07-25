import { Model, Column, Table, PrimaryKey, CreatedAt, AutoIncrement, BelongsTo, ForeignKey, HasMany } from "sequelize-typescript";
import CategoryGroup from "./CategoryGroup.model";
import Question from "./Question.model"

@Table({ updatedAt: false })
export default class Category extends Model<Category> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @Column
    name: string;

    @ForeignKey(() => CategoryGroup)
    @Column
    categoryGroupId: number;

    @BelongsTo(() => CategoryGroup)
    categoryGroup: CategoryGroup;

    @HasMany(() => Question)
    questions: Question[];

    @CreatedAt
    createdAt: Date;
}